import 'package:firebase/controller/homeController.dart';
import 'package:firebase/firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
                  String msg =
                      await loginemailpass(txtemail.text, txtpassword.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$msg"),
                    ),
                  );
                  if (msg == "Success") {
                    Get.offNamed('/home');
                  }
                },
                child: Text("Signin"),
              ),
              TextButton(
                onPressed: () async {
                  bool msg = await googlelogin();

                  if (msg) {
                    Get.offNamed('/home');
                  }
                },
                child: Text("Login With Google"),
              ),
              SizedBox(
                height: 100,
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                },
                child: Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
