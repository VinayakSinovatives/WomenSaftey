/*import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late AudioPlayer _audioPlayer; // Audio player instance
  bool _isAlarmActive = false; // Track alarm state

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  // Function to toggle the alarm
  void _toggleAlarm() async {
    if (_isAlarmActive) {
      // Stop the alarm if it's active
      await _audioPlayer.stop();
    } else {
      // Play the scream sound if it's not active
      await _audioPlayer.play(AssetSource('police_siren.mp3'));
    }

    setState(() {
      _isAlarmActive = !_isAlarmActive; // Toggle the state
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the audio player when done
    super.dispose();
  }

  // Function to show explanation about the alarm feature
  void _showAlarmExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("How the Alarm Works"),
          content: Text(
            "This alarm feature is designed to help you alert others in case of an emergency.\n\n"
            "When you tap 'Activate Alarm', a loud siren or scream sound will play from your device, alerting others nearby.\n\n"
            "If you no longer need the alarm, tap 'Deactivate Alarm'. The sound will stop, and you can turn it back on whenever needed.\n\n"
            "Use this feature to get immediate attention or scare off potential threats in an emergency situation.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Got it!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          // Information button to explain how the alarm works
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showAlarmExplanation(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Explanation text about the alarm feature
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Activate the alarm to send a loud sound to alert others in case of danger.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Tap the button to activate or deactivate the alarm.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleAlarm,
              child: Text(
                _isAlarmActive ? 'Deactivate Alarm' : 'Activate Alarm', // Button text
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAlarmActive ? Colors.red : Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
//___________________________________________________________________________________




// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:battery/battery.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:women/db/db_services.dart';
// import 'package:women/model/contactsm.dart';
// import 'package:women/widgets/home_widgets/safehome/SafeHome.dart';

// class ReviewPage extends StatefulWidget {
//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   late AudioPlayer _audioPlayer; // Audio player instance
//   bool _isAlarmActive = false; // Track alarm state
//   final Battery _battery = Battery(); // Battery instance
//   int _batteryLevel = 100; // Battery level percentage
//   double? latitude; // Latitude to store current location
//   double? longitude; // Longitude to store current location

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _checkBattery(); // Check the battery status on app start
//   }

//   // Function to check battery status
//   void _checkBattery() async {
//     _batteryLevel = await _battery.batteryLevel; // Get battery level
//     if (_batteryLevel >= 10 && !_isAlarmActive) {
//       _toggleAlarm(); // Automatically activate the alarm if battery is low
//       _getCurrentLocation(); // Fetch current location when battery is low
//     }
//   }

//   // Function to fetch the current location
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Fluttertoast.showToast(msg: "Location services are disabled.");
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           Fluttertoast.showToast(msg: "Location permission denied.");
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         Fluttertoast.showToast(
//             msg: "Location permission permanently denied. Please enable it from settings.");
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         latitude = position.latitude;
//         longitude = position.longitude;
//       });

//       _sendLocationToContacts(); // Now send the location once fetched
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error fetching location: $e");
//     }
//   }

//   // Function to send the location to contacts
//   Future<void> _sendLocationToContacts() async {
//     if (latitude == null || longitude == null) {
//       Fluttertoast.showToast(msg: "Please fetch your location first.");
//       return;
//     }

//     try {
//       List<TContact> contactList = await DatabaseHelper().getContactList();
//       String message =
//           "My battery is low! My current location is: https://www.google.com/maps?q=$latitude,$longitude";

//       int successCount = 0;
//       int failureCount = 0;

//       for (TContact contact in contactList) {
//         Uri smsUri = Uri.parse("sms:${contact.number}?body=${Uri.encodeComponent(message)}");
//         if (await launchUrl(smsUri)) {
//           successCount++;
//         } else {
//           failureCount++;
//         }
//       }

//       Fluttertoast.showToast(
//         msg: "Alerts sent: $successCount, Failed: $failureCount",
//       );
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error sending alerts: $e");
//     }
//   }

//   // Function to toggle the alarm
//   void _toggleAlarm() async {
//     if (_isAlarmActive) {
//       // Stop the alarm if it's active
//       await _audioPlayer.stop();
//     } else {
//       // Play the scream sound if it's not active
//       await _audioPlayer.play(AssetSource('police_siren.mp3'));
//     }

//     setState(() {
//       _isAlarmActive = !_isAlarmActive; // Toggle the state
//     });
//   }

//   // Function to show explanation about the alarm feature
//   void _showAlarmExplanation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("How the Alarm Works"),
//           content: Text(
//             "This alarm feature is designed to help you alert others in case of an emergency.\n\n"
//             "When you tap 'Activate Alarm', a loud siren or scream sound will play from your device, alerting others nearby.\n\n"
//             "Additionally, if your device battery goes below 10%, the alarm will automatically activate and send your location to your emergency contacts to help you.",
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text("Got it!"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose(); // Dispose the audio player when done
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Setting"),
//         actions: [
//           // Information button to explain how the alarm works
//           IconButton(
//             icon: Icon(Icons.info_outline),
//             onPressed: () => _showAlarmExplanation(context),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Explanation text about the alarm feature
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Text(
//                 "Activate the alarm to send a loud sound to alert others in case of danger.",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Text(
//                 "Tap the button to activate or deactivate the alarm.",
//                 style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: _toggleAlarm,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     _isAlarmActive ? Icons.volume_off : Icons.volume_up,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     _isAlarmActive ? 'Deactivate Alarm' : 'Activate Alarm', // Button text
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _isAlarmActive ? Colors.red : Colors.green,
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 elevation: 5,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Battery Level: $_batteryLevel%',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class ReviewPage extends StatefulWidget {
//   const ReviewPage({super.key});

//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   final TextEditingController _reviewController = TextEditingController();
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();

//   // Submit a review
//   Future<void> submitReview() async {
//     if (_key.currentState!.validate()) {
//       try {
//         final user = FirebaseAuth.instance.currentUser;
//         if (user != null) {
//           await FirebaseFirestore.instance.collection('reviews').add({
//             'userId': user.uid,
//             'review': _reviewController.text,
//             'timestamp': FieldValue.serverTimestamp(),
//           });
//           Fluttertoast.showToast(msg: "Review submitted successfully!");
//           _reviewController.clear();
//           Navigator.pop(context); // Close the bottom sheet after submission
//         } else {
//           Fluttertoast.showToast(msg: "Please log in to submit a review.");
//         }
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Failed to submit review: $e");
//       }
//     }
//   }

//   // Fetch and display reviews
//   Widget _buildReviewList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('reviews')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Text(
//               "No reviews available.",
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           );
//         }
//         return ListView.builder(
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             final review = snapshot.data!.docs[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.pink.shade200,
//                   child: Icon(Icons.person, color: Colors.white),
//                 ),
//                 title: Text(
//                   review['review'],
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 subtitle: Text(
//                   "User: ${review['userId']}",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // Show Bottom Sheet for Adding a Review
//   void _showAddReviewSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 20,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//           ),
//           child: Form(
//             key: _key,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Add a Review",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _reviewController,
//                   decoration: InputDecoration(
//                     hintText: "Write your review...",
//                     border: OutlineInputBorder(),
//                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   ),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter a review.";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: submitReview,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pink,
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text(
//                     "Submit",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Reviews"),
//         backgroundColor: Colors.pink,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Expanded(child: _buildReviewList()),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddReviewSheet,
//         backgroundColor: Colors.pink,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//import 'package:audioplayers/audioplayers.dart';
  import 'package:audioplayers/audioplayers.dart';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart'; 
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
 
  class ReviewPage extends StatefulWidget {
    @override
    State<ReviewPage> createState() => _ReviewPageState();
  }

  class _ReviewPageState extends State<ReviewPage> {
    late AudioPlayer _audioPlayer;
    bool _isAlarmActive = false;
   
    

    final TextEditingController _reviewController = TextEditingController();
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

//    ThemeMode _themeMode = ThemeMode.light; // Default theme mode

    @override
    void initState() {
      super.initState();
      _audioPlayer = AudioPlayer();
   //   _loadTheme(); // Load saved theme on init
    }

    // Function to load the saved theme preference
    // void _loadTheme() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    //   setState(() {
    //     _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    //   });
    // }

    // Function to toggle between light and dark theme
    // void _toggleTheme() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   setState(() {
    //     if (_themeMode == ThemeMode.light) {
    //       _themeMode = ThemeMode.dark;
    //     } else {
    //       _themeMode = ThemeMode.light;
    //     }
    //     prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    //   });
    // }

    // Function to check battery level
    

    // Function to fetch current location
    

    // Function to toggle alarm (play/pause sound)
    void _toggleAlarm() async {
      if (_isAlarmActive) {
        await _audioPlayer.stop();
      } else {
        await _audioPlayer.play(AssetSource('police_siren.mp3'));
      }

      setState(() {
        _isAlarmActive = !_isAlarmActive;
      });
    }

    // Function to show alarm explanation
    void _showAlarmExplanation(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("How the Alarm Works"),
            content: Text(
              "This alarm feature is designed to help you alert others in case of an emergency.\n\n"
              "When you tap 'Activate Alarm', a loud siren or scream sound will play from your device, alerting others nearby.\n\n"
              "Additionally, if your device battery goes below 10%, the alarm will automatically activate and send your location to your emergency contacts to help you.",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Got it!"),
              ),
            ],
          );
        },
      );
    }

    // Function to logout the user
    

    // Function to submit review
    Future<void> submitReview() async {
      if (_key.currentState!.validate()) {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance.collection('reviews').add({
              'userId': user.uid,
              'review': _reviewController.text,
              'timestamp': FieldValue.serverTimestamp(),
            });
            Fluttertoast.showToast(msg: "Review submitted successfully!");
            _reviewController.clear();
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(msg: "Please log in to submit a review.");
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "Failed to submit review: $e");
        }
      }
    }

    // Widget to build the review list
    Widget _buildReviewList() {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No reviews available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final review = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink.shade200,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    review['review'],
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    "User: ${review['userId']}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    // Widget to show add review sheet
    void _showAddReviewSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add a Review",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: "Write your review...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a review.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Cleanup resources
    @override
    void dispose() {
      _audioPlayer.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        // themeMode: _themeMode, // Set theme mode
        // theme: ThemeData.light(), // Light theme
        // darkTheme: ThemeData.dark(), // Dark theme
        home: Scaffold(
          appBar: AppBar(
            title: Text("Reviews"),
            actions: [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'Activate Alarm') {
                    _toggleAlarm();
                  
                  }else if (value == 'Info') {
                    _showAlarmExplanation(context);
                   }// else if (value == 'Theme') {
                  //   _toggleTheme(); // Add theme toggle option
                  // }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Activate Alarm',
                      child: Text('Activate Alarm'),
                    ),
                    
                    PopupMenuItem<String>(
                      value: 'Info',
                      child: Text('How the Alarm Works'),
                    ),
                    // PopupMenuItem<String>(
                    //   value: 'Theme',
                    //   child: Text('Toggle Dark/Light Theme'),
                    // ),
                  ];
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(child: _buildReviewList()),
                SizedBox(height: 20),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddReviewSheet,
            backgroundColor: Colors.pink,
            child: Icon(Icons.add),
          ),
        ),
      );
    }
  }

