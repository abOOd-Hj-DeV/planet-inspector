import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../screens/auth_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/results_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const welcome = '/essential';
  static const login = '/login';
  static const register = '/sign';
  static const history = '/history';
  static const results = '/mainp';
  static const home = '/a';

  static List<GetPage<dynamic>> get pages => [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: login, page: () => const AuthScreen()),
    GetPage(name: register, page: () => const AuthScreen(isRegister: true)),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      middlewares: [SessionGuard()],
    ),
    GetPage(
      name: history,
      page: () => const HistoryScreen(),
      middlewares: [SessionGuard()],
    ),
    GetPage(
      name: results,
      page: () => const ResultsScreen(),
      middlewares: [SessionGuard()],
    ),
  ];
}

class SessionGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      Get.find<AuthController>().isLoggedIn.value
      ? null
      : const RouteSettings(name: AppRoutes.welcome);
}
