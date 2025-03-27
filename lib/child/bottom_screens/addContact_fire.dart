import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../child_login_screen.dart';
import 'contacts_fire.dart';
// class AddcontactFire extends StatefulWidget {
//   const AddcontactFire({super.key});

//   @override
//   State<AddcontactFire> createState() => _AddcontactFireState();
// }

// class _AddcontactFireState extends State<AddcontactFire> {
//   Stream<List<Map<String, dynamic>>> _getContactsStream() {
// final user = FirebaseAuth.instance.currentUser;
// if (user != null) {
//   final userId = user.uid;
//   print("User ID: $userId");
//   // Proceed with your app's functionality
// } else {
//   print("User not logged in.");
//   // Redirect to the login page
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(builder: (context) => LoginScreen()),
//   );
// }

//     return FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('contacts')
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) {
//               final data = doc.data();
//               return {
//                 'id': doc.id,
//                 'name': data['name'],
//                 'mobileNumber': data['mobileNumber'],
//                 'relation': data['relation'],
//               };
//             }).toList());
//   }

//   Future<void> _makePhoneCall(String number) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: number);

//     try {
//       PermissionStatus status = await Permission.phone.request();

//       if (status.isGranted) {
//         bool launched = await launchUrl(phoneUri, mode: LaunchMode.externalApplication);

//         if (!launched) {
//           Fluttertoast.showToast(
//               msg: "Could not place call. Please check the number format or permissions.");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Permission denied. Cannot make a call.");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     }
//   }

//   Future<void> _deleteContact(String contactId) async {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('contacts')
//         .doc(contactId)
//         .delete();
//     Fluttertoast.showToast(msg: "Contact removed successfully");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Emergency Contacts'),
//         backgroundColor: Colors.pink,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const ContactsFire(),
//                     //MaterialPageRoute(builder: (context) => const ContactsPage(userId: 'userId: FirebaseAuth.instance.currentUser!.uid'),

//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink,
//                 ),
//                 child: const Text("Add Emergency Contacts"),
//               ),
//               Expanded(
//                 child: StreamBuilder<List<Map<String, dynamic>>>(
//                   stream: _getContactsStream(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       return Center(child: Text("Error: ${snapshot.error}"));
//                     }
//                     if (!snapshot.hasData) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     final contacts = snapshot.data!;
//                     return ListView.builder(
//                       itemCount: contacts.length,
//                       itemBuilder: (context, index) {
//                         final contact = contacts[index];
//                         return Card(
//                           color: Colors.pink.shade50,
//                           child: ListTile(
//                             title: Text(contact['name']),
//                             subtitle: Text(
//                                 "${contact['relation']} - ${contact['mobileNumber']}"),
//                             trailing: SizedBox(
//                               width: 100,
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     onPressed: () async {
//                                       await _makePhoneCall(
//                                           contact['mobileNumber']);
//                                     },
//                                     icon: const Icon(
//                                       Icons.call,
//                                       color: Colors.pink,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: () async {
//                                       await _deleteContact(contact['id']);
//                                     },
//                                     icon: const Icon(
//                                       Icons.delete,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class AddcontactFire extends StatefulWidget {
  const AddcontactFire({super.key});

  @override
  State<AddcontactFire> createState() => _AddcontactFireState();
}

class _AddcontactFireState extends State<AddcontactFire> {
  late final String? userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    } else {
      userId = null;
      // Redirect to the login page if user is not logged in
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  Stream<List<Map<String, dynamic>>> _getContactsStream() {
    if (userId == null) {
      return const Stream.empty(); // Return an empty stream if userId is null
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'name': data['name'],
                'mobileNumber': data['mobileNumber'],
                //'relation': data['relation'],
              };
            }).toList());
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);

    try {
      PermissionStatus status = await Permission.phone.request();

      if (status.isGranted) {
        bool launched = await launchUrl(phoneUri, mode: LaunchMode.externalApplication);

        if (!launched) {
          Fluttertoast.showToast(
              msg: "Could not place call. Please check the number format or permissions.");
        }
      } else {
        Fluttertoast.showToast(msg: "Permission denied. Cannot make a call.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  Future<void> _deleteContact(String contactId) async {
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .doc(contactId)
          .delete();
      Fluttertoast.showToast(msg: "Contact removed successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactsFire(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                child: const Text("Add Emergency Contacts"),
              ),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _getContactsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final contacts = snapshot.data!;
                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Card(
                          color: Colors.pink.shade50,
                          child: ListTile(
                            title: Text(contact['name']),
                            subtitle: Text(
                                "${contact['mobileNumber']}"),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await _makePhoneCall(
                                          contact['mobileNumber']);
                                    },
                                    icon: const Icon(
                                      Icons.call,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await _deleteContact(contact['id']);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
