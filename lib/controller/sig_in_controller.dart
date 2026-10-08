import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_finder/view/history.dart';

class SigController extends GetxController {
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(), 
    GlobalKey<FormState>(), 
    GlobalKey<FormState>(), 
    GlobalKey<FormState>(), 
  ];

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    super.onClose();
  }

  butt() async {
  
  bool isValid = formKeys.every((key) => key.currentState?.validate() ?? false);
  
  if (isValid) {
    try {
      await authController.register(
        fullNameController.text,
        emailController.text,
        passwordController.text,
      );
      Get.offNamed('/login');

      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear(); 

    } catch (e) {
      print('Error: $e');
    }
  }
}



}
