import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_finder/controller/auth_controller.dart';
import 'package:plant_finder/controller/login_controller.dart';

// ignore: non_constant_identifier_names
final AuthController authController = Get.put(AuthController());
final LoginController logController = Get.put(LoginController());

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFFF8F6F1),
            child: ListView(
              children: [
                Container(
                  height: 300,
                  width: 300,
                  color: const Color(0xFFF8F6F1),
                  child: Image.asset("img/flower.png"),
                ),
                Container(
                    alignment: Alignment.center,
                    child: const Text(
                      " WELCOME\n     BACK!",
                      style: TextStyle(
                          color: Color(0xff396f61),
                          fontWeight: FontWeight.normal,
                          fontSize: 35),
                    )),
                Container(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: logController.formKey[0],
                    child: TextFormField(
                      controller: logController.eemailController,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none,
                        ),
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: const TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                        ),
                        fillColor: const Color(0xffececec),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        isDense: true,
                      ),
                      style: const TextStyle(height: 1.9),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required.';
                        }
                        String pattern =
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: logController.formKey[1],
                    child: TextFormField(
                      obscureText: true,
                      controller: logController.ppasswordController,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none,
                        ),
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                        ),
                        fillColor: const Color(0xffececec),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        isDense: true,
                      ),
                      style: const TextStyle(height: 1.9),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  height: 40,
                ),
                InkWell(
                    onTap: () async {
                      logController.buttt();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: const Color(0xffb8d295)),
                      height: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.center,
                      child: const Text(
                        "Log in ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    )),
                Container(
                  height: 14,
                ),
                InkWell(
                    child: Container(
                  alignment: Alignment.center,
                  child: const InkWell(
                      child: Text(
                    "Forgot your password ?",
                    style: TextStyle(
                      color: Color(0xffec9c67),
                      fontSize: 10,
                    ),
                  )),
                )),
                const SizedBox(
                  height: 155,
                )
              ],
            )));
  }
}
