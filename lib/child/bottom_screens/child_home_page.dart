import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore
import 'package:uuid/uuid.dart';

import '../../widgets/LiveSafe.dart';
import '../../widgets/home_widgets/customCarouel.dart';
import '../../widgets/home_widgets/custom_appBar.dart';
import '../../widgets/home_widgets/emergency.dart';
import '../../widgets/home_widgets/safehome/SafeHome.dart';
//import 'package:women/child/bottom_screens/shake_phone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int qindex = 0;
  bool isShaking = false;
  bool isAlertSent = false;
  DateTime? shakeStartTime;
  StreamSubscription? accelerometerSubscription;

  List<String> trustedContacts = []; // List of trusted contact numbers
  int remainingTime = 1; // Time left for the shake detection (in seconds)
  Timer? countdownTimer;
  Timer? messageDisplayTimer; // Timer to control message display duration

  // Generate random quote index
  getRandomQuote() {
    Random random = Random();
    setState(() {
      qindex = random.nextInt(3); // Assuming 3 quotes are available
    });
  }

  @override
  void initState() {
    super.initState();
    getRandomQuote();
    fetchTrustedContacts();
    startShakeDetection();
  
    
  }


  void startShakeDetection() {
    const double shakeThreshold = 12.0; // Adjust threshold as needed

    accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration = sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z);

      if (acceleration > shakeThreshold) {
        if (!isShaking) {
          shakeStartTime = DateTime.now();
          isShaking = true;
          remainingTime = 1; // Reset countdown
          isAlertSent = false;
          startCountdown();
        }
      } else {
        stopCountdown();
        isShaking = false;
      }
    });
  }

  void startCountdown() {
    countdownTimer?.cancel(); // Cancel any existing timer
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        if (!isAlertSent) {
          sendLiveLocationToTrustedContacts();
          stopCountdown();
          isShaking = false;
        }
      }
    });
  }

  void stopCountdown() {
    countdownTimer?.cancel();
    setState(() {
      remainingTime = 0;
    });
  }

  void showMessageForDuration() {
    // Show the message dynamically during the countdown
    messageDisplayTimer?.cancel(); // Cancel any existing timer
    messageDisplayTimer = Timer(Duration(seconds: 30), () {
      setState(() {
        isShaking = false;
      });
      stopCountdown();
    });
  }

  Future<void> fetchTrustedContacts() async {
    try {
      String userId = "exampleUserId"; // Replace with actual user ID logic

      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .get();

      setState(() {
        trustedContacts = snapshot.docs
            .map((doc) => doc['phone_number'] as String)
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch contacts: $e')),
      );
    }
  }

  Future<void> sendLiveLocationToTrustedContacts() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String message =
          "Emergency! Here is my live location: https://www.google.com/maps?q=${position.latitude},${position.longitude}";

      for (String contact in trustedContacts) {
        String encodedMessage = Uri.encodeComponent(message);
        Uri smsUri = Uri.parse("sms:$contact?body=$encodedMessage");

        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        } else {
          throw 'Could not launch SMS to $contact';
        }
      }

      String emergencyNumber = "100"; // Emergency number for your country
      Uri callUri = Uri.parse("tel:$emergencyNumber");
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        throw 'Could not make a call to $emergencyNumber';
      }

//send data to firebase 
   String userId = FirebaseAuth.instance.currentUser?.uid ?? "Unknown User";
    String alertId = Uuid().v4(); // Generate a unique alert ID

    // Prepare alert data
    final alertData = {
      'alert_name': 'shake phone Alert',
      'alert_id': alertId,
      'timestamp': FieldValue.serverTimestamp(),
      //'location': "", // Include location if available
    };

 await FirebaseFirestore.instance
        .collection('users')        // Access 'users' collection
        .doc(userId)                // Access user's document
        .collection('sos_alert')    // Create the sos_alert collection inside the user document
        .add(alertData);  



      setState(() {
        isAlertSent = true; // Mark alert as sent
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alert sent ... emergency call made!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send location or make a call: $e')),
      );
    }
  }

  @override
  void dispose() {
    accelerometerSubscription?.cancel();
    countdownTimer?.cancel();
    messageDisplayTimer?.cancel();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomAppbar(
                    quoteIndex: qindex,
                    onTap: getRandomQuote,
                  ),
                  Customcarouel(),
                  if (isShaking && !isAlertSent)
                    ClipOval(
                      child: Container(
                        color: Colors.red[50],
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Shaking detected! Sending alert in $remainingTime seconds...",
                          style: TextStyle(color: Colors.red, fontSize: 30),
                        ),
                      ),
                    ),
                  if (isShaking && !isAlertSent)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isShaking = false;
                          stopCountdown();
                          remainingTime = 0;
                        });
                      },
                      child: Text("Cancel"),
                    ),
                  if (isShaking && !isAlertSent)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Trusted Contacts:",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          for (String contact in trustedContacts)
                            Text(contact), // Show each contact
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Emergency",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Emergency(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Explore LiveSafe",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Livesafe(),
                  SafeHome(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
