import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF8F6F1);
  static const green = Color(0xff396f61);
  static const leaf = Color(0xff739f6a);
  static const lightGreen = Color(0xffb8d295);
  static const orange = Color(0xffec9c67);
}

ThemeData get appTheme => ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.green,
    primary: AppColors.green,
    surface: AppColors.background,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.green,
    elevation: 0,
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xffececec),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: AppColors.green),
    ),
    errorMaxLines: 2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.leaf,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 48),
      elevation: 0,
      shape: const StadiumBorder(),
    ),
  ),
);
