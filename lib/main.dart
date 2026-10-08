import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_finder/controller/auth_controller.dart';
import 'package:plant_finder/view/a.dart';
import 'package:plant_finder/view/essential.dart';
import 'package:plant_finder/view/history.dart';
import 'package:plant_finder/view/login.dart';
import 'package:plant_finder/view/main_page.dart';
import 'package:plant_finder/view/sigin_up.dart';
import 'package:plant_finder/view/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SharedPreferences.getInstance());
  Get.put(AuthController());

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    debugShowCheckedModeBanner: false,

      getPages: [
      GetPage(name: "/", page: () => const Splash(),),
      GetPage(name: "/essential", page: ()=>const Ess()),
      GetPage(name: "/login", page: ()=>const Login()),
      GetPage(name: "/sign", page: ()=>const SiginUp() ),
      GetPage(name: "/history", page:()=>const History()),
      GetPage(name: "/mainp", page:()=>const  MainPage()),
      GetPage(name: "/a", page: () => const A(),),

      ],
);
}}
