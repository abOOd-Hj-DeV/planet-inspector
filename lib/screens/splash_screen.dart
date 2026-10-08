import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _failed = false;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), _restore);
  }

  Future<void> _restore() async {
    setState(() => _failed = false);
    try {
      final auth = Get.find<AuthController>();
      await auth.restoreSession();
      if (mounted) {
        Get.offAllNamed(
          auth.isLoggedIn.value ? AppRoutes.home : AppRoutes.welcome,
        );
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('img/splash.jpg', fit: BoxFit.cover),
        if (_failed)
          SafeArea(
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Could not restore your session.'),
                      TextButton(
                        onPressed: _restore,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
