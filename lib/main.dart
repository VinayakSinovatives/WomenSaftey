import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_panel/main_screen.dart';
import 'child/bottom_page.dart';
import 'child/bottom_screens/low_battery.dart';
import 'child/child_login_screen.dart';
import 'db/shared_pref.dart';
import 'parent/parent_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBxzLqJGbAFfCZijNfQYC8RBJs55Iwiurw",
      appId: "1:620587610556:android:73ab10e4a89b440a4dfbb9",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      projectId: "women-safety-2a87e",
      authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
      storageBucket: "women-safety-2a87e.firebasestorage.app",
      // Optional: Add a name for your app instance
    ),
  );
  MySharedPreference.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LowBatteryAlert _lowBatteryAlert = LowBatteryAlert();

  @override
  void initState() {
    super.initState();
    _checkUserAndBattery();
  }

  // Call the low battery check when the app starts
  // Call the low battery check only for the child user
  void _checkUserAndBattery() async {
    String userType = await MySharedPreference.getUserType();

    // Check if the user is a 'child'
    if (userType == "child") {
      await _lowBatteryAlert.checkBattery();
    }
  }

  // Initialize shake detection and provide the callback
  /* void _initializeShakeDetection() {
    _shakeService.startListening(() async {
      const String policeHelpline = '100'; // Replace with your helpline number
      try {
        await _shakeService.callHelpline(policeHelpline);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    });
  }*/
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rakshak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: MySharedPreference.getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == "") {
              return LoginScreen();
            }

            if (snapshot.data == "child") {
              return BottomPage();
            }

            if (snapshot.data == "parent") {
              return ParentHomeScreen();
            }

            if (snapshot.data == "admin") {
              return MainDashboard();
            }
            return showLoadingDialog(context);
          }),
    );
  }
}

Widget showLoadingDialog(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}