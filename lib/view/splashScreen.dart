import 'dart:async';

import 'package:firebase/firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  bool msg = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    msg = checkUser();
  }

  @override
  Widget build(BuildContext context) {
    
    Timer(
      Duration(seconds: 3),
        ()=> msg?Get.offNamed('/home'):Get.offNamed('/signin')
    );
    
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: 270,
            width: 270,
            child: Image.network(
                "https://www.gifcen.com/wp-content/uploads/2022/03/luffy-gif-1.gif"),
          ),
        ),
      ),
    );
  }
}
