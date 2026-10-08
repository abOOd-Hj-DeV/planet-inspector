// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_finder/controller/sig_in_controller.dart';

final SigController sigController = Get.put(SigController());


class SiginUp extends StatelessWidget {
  const SiginUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            color: const Color(0xFFF8F6F1),
            child: ListView(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  color: const Color(0xFFF8F6F1),
                  child: Image.asset("img/flower.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "       CREAT\nNEW ACCOUNT",
                      style: TextStyle(
                          color: Color(0xff396f61),
                          fontWeight: FontWeight.normal,
                          fontSize: 35),
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Already Registerd ? ",
                        style: TextStyle(
                            color: Color(0xff396f61),
                            fontWeight: FontWeight.normal,
                            fontSize: 10),
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: const InkWell(
                        child: Text(
                      "Login here",
                      style: TextStyle(
                        color: Color(0xffec9c67),
                        fontSize: 10,
                      ),
                    )),
                  ),
                ]),
                Container(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: sigController.formKeys[0],
                    child: TextFormField(
                      controller: sigController.fullNameController,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                              color: Colors.red, width: 1), 
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none, 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide:
                              BorderSide.none, 
                        ),
                        border: InputBorder.none,
                        hintText: "Full name",
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

                      style: const TextStyle(
                          height: 1.9), 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null; 
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: sigController.formKeys[1],
                    child: TextFormField(
                      controller: sigController.emailController,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                              color: Colors.red, width: 1), 
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1), 
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none, 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide:
                              BorderSide.none, 
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
                      style: const TextStyle(
                          height: 1.9),
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
                    key: sigController.formKeys[2],
                    child: TextFormField(
                      obscureText: true,
                      controller: sigController.passwordController,
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
                        return null;                       },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: sigController.formKeys[3],
                    child: TextFormField(
                      obscureText: true,
                      controller: sigController.confirmPasswordController,
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
                        hintText: "Confirm Password",
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
                        if (value != sigController.passwordController.text) {
                          return 'The password does not match.'; 
                        }
                        return null; 
                      },
                    ),
                  ),
                ),

                Container(
                  height: 25,
                ),
                Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "By continuing, you agree with our Term &\n      Condition and Privacy Policy",
                      style: TextStyle(
                          color: Color.fromARGB(255, 35, 77, 66),
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    )),
                Container(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    sigController.butt();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: const Color(0xff326e62),
                    ),
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 14,
                ),
                const SizedBox(
                  height: 135,
                )
              ],
            )));
  }
}
