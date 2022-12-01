import 'package:firebase/controller/homeController.dart';
import 'package:firebase/firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: txtemail,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Obx(
                () => TextField(
                  controller: txtpassword,
                  obscureText: homeController.obsecure.value,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (homeController.obsecure.value) {
                          homeController.obsecure.value = false;
                        } else {
                          homeController.obsecure.value = true;
                        }
                      },
                      icon: Icon(homeController.obsecure.value == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () async {
                    String msg = await signup(txtemail.text, txtpassword.text);
                    if (msg == "Success") {
                      Get.back();
                    }
                  },
                  child: Text("Signup"))
            ],
          ),
        ),
      ),
    );
  }
}
