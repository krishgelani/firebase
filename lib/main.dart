import 'package:firebase/view/homeScreen.dart';
import 'package:firebase/view/signinScreen.dart';
import 'package:firebase/view/signupScreen.dart';
import 'package:firebase/view/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/':(p0) => SplashScreen(),
        '/signin':(p0) => SigninScreen(),
        '/signup':(p0) => SignupScreen(),
        '/home':(p0) => HomeScreen(),
      },
    ),
  );
}