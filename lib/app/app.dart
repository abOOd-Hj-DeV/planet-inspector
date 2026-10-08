import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme.dart';
import 'routes.dart';

class PlantFinderApp extends StatelessWidget {
  const PlantFinderApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Plant Finder',
    debugShowCheckedModeBanner: false,
    theme: appTheme,
    initialRoute: AppRoutes.splash,
    getPages: AppRoutes.pages,
  );
}
