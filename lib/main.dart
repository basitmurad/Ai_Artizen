

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/SplashScreen.dart';


void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with error handling
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
    runApp(MyApp());
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Still run the app but with limited functionality
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Artizen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
