import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_theme.dart';
import '../app/routes.dart';
import '../widgets/page_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: PageBody(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        children: [
          const FlowerHeader(height: 300),
          const Text(
            'PLANT\nFINDER',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.green, fontSize: 35),
          ),
          const SizedBox(height: 20),
          const Text(
            'Upload a photo to discover your plant and keep your discoveries in one place.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.green),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.register),
            child: const Text('Sign Up'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightGreen,
              foregroundColor: AppColors.green,
            ),
            onPressed: () => Get.toNamed(AppRoutes.login),
            child: const Text('Log In'),
          ),
        ],
      ),
    ),
  );
}
