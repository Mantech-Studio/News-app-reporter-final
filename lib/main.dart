import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/LoginScreen.dart';
import 'package:news_app_reporter/PageController.dart';

void main() async {
  //Checking if user is Signed In
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser?.uid == null) {
    // Go to Login Page if user is Signed Out
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ));
  } else {
    //Go to Home Page if user is Signed In
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageControllerScreen(),
    ),
    );
  }
}
