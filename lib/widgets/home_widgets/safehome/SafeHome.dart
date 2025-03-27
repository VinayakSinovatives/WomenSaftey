


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/PrimaryButton.dart';

class SafeHome extends StatefulWidget {
  const SafeHome({Key? key}) : super(key: key);

  @override
  _SafeHomeState createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  String locationMessage = 'Current location not fetched';
  String? latitude;
  String? longitude;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Location services are disabled.");
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission denied.");
        return Future.error('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Location permission permanently denied. Please enable it from settings.");
      return Future.error('Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

 // import 'package:url_launcher/url_launcher.dart';

void _openGoogleMaps() async {
  if (latitude != null && longitude != null) {
    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps?q=$latitude,$longitude");

    // Use launchUrl from url_launcher package
    if (await launchUrl(
      googleMapsUri,
      mode: LaunchMode.externalApplication, // Opens in Google Maps app or browser
    )) {
      print("Google Maps opened successfully.");
    } else {
      Fluttertoast.showToast(msg: "Could not open Google Maps.");
    }
  } else {
    Fluttertoast.showToast(msg: "Please fetch your location first.");
  }
}
 
 

Future<void> _sendLocationToContacts() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    Fluttertoast.showToast(msg: "User not logged in.");
    return;
  }

  // Check if latitude and longitude are fetched
  if (latitude == null || longitude == null) {
    Fluttertoast.showToast(msg: "Please fetch your location first.");
    return;
  }

  try {
    // Store location in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('location')
        .doc('current_location')
        .set({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Fetch emergency contacts
    QuerySnapshot contactsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .get();

    if (contactsSnapshot.docs.isEmpty) {
      Fluttertoast.showToast(msg: "No emergency contacts found.");
      return;
    }

   
    // Prepare message
    String message =
        "I need help! My current location is: https://www.google.com/maps?q=$latitude,$longitude";

 
 List<String> contactNumbers = [];
    for (QueryDocumentSnapshot contactDoc in contactsSnapshot.docs) {
      final contactData = contactDoc.data() as Map<String, dynamic>;
      final contactNumber = contactData['mobileNumber'];
      if (contactNumber != null && contactNumber.isNotEmpty) {
        contactNumbers.add(contactNumber);
      }
    }

    if (contactNumbers.isEmpty) {
      Fluttertoast.showToast(msg: "No valid contact numbers found.");
      return;
    }

    // Combine all contact numbers into a single URI
    Uri smsUri = Uri.parse(
      "sms:${contactNumbers.join(',')}?body=${Uri.encodeComponent(message)}",
    );

    // Launch SMS app with the prepared URI
    if (await launchUrl(smsUri)) {
      Fluttertoast.showToast(msg: "SMS app launched successfully.");
    } else {
      Fluttertoast.showToast(msg: "Could not launch SMS app.");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: $e");
  }
  
}




void showModelSafeHome(BuildContext context) {
  bool isFetchingLocation = false; // New state to track location fetching

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR EMERGENCY CONTACTS",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(locationMessage),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: isFetchingLocation
                        ? null // Disable button while fetching
                        : () {
                            setState(() {
                              isFetchingLocation = true; // Start fetching
                            });

                            _getCurrentLocation().then((position) {
                              setState(() {
                                latitude = position.latitude.toString();
                                longitude = position.longitude.toString();
                                locationMessage =
                                    "Latitude: $latitude, Longitude: $longitude";
                              });
                              Fluttertoast.showToast(
                                  msg: "Location fetched successfully.");
                            }).catchError((error) {
                              Fluttertoast.showToast(
                                  msg: "Error fetching location: $error");
                            }).whenComplete(() {
                              setState(() {
                                isFetchingLocation = false; // Reset state
                              });
                            });
                          },
                    child: isFetchingLocation
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text("Get Location"),
                  ),
                  SizedBox(height: 10),
                  PrimaryButton(
                    onPressed: _openGoogleMaps,
                    title: ("Open in Google Maps"),
                  ),
                  SizedBox(height: 20),
                  PrimaryButton(
                    onPressed: _sendLocationToContacts,
                    title: ("Send Location"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafeHome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Send Location'),
                      subtitle: Text("Share your location"),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/location.jpg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


