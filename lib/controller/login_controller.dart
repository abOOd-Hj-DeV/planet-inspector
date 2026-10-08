import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_finder/view/history.dart';

class LoginController extends GetxController {
  final TextEditingController eemailController = TextEditingController();
  final TextEditingController ppasswordController = TextEditingController();

  final List<GlobalKey<FormState>> formKey = [
    GlobalKey<FormState>(), 
    GlobalKey<FormState>(), 
  ];

  Future<void> buttt() async {
    bool isValid = formKey.every((key) => key.currentState?.validate() ?? false);

    if (isValid) {
      try {
        bool success = await authController.login(
          eemailController.text,
          ppasswordController.text,
        );
        if (success) {
          Get.offNamed('/a');
        } else {
          Get.snackbar('Error', 'Invalid email or password');
        }
      } catch (e) {
        print('Error: $e');
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
    } else {
      Get.snackbar('Validation Error', 'Please fill in all fields correctly.');
    }
  }


  @override
void onClose() {
  eemailController.clear();
  ppasswordController.clear();
  super.onClose();
}
  

}
