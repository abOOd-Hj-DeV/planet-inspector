import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_finder/controller/auth_controller.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
final AuthController authController = Get.find();

    Future.delayed(const Duration(seconds: 4), () {
      authController.checkLoginStatus();
    });


    return Scaffold(
      body: Center(
        child: SizedBox(
          width:
              MediaQuery.of(context).size.width * 100,
          height: MediaQuery.of(context).size.height *
              100, 
          child: Image.asset(
            "img/splash.jpg", 
            fit: BoxFit.cover, 
          ),
        ),
      ),
    );
  }
}

