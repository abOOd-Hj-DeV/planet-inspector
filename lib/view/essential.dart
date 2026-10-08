import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Ess extends StatelessWidget {
  const Ess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFFF8F6F1),
            child: Column(
              children: [
                Container(
                  color: const Color(0xFFF8F6F1),
                  child: Image.asset("img/flower.png"),
                ),
                Container(
                    alignment: Alignment.center,
                    child: const Text(
                      " PLANT\n FINDER",
                      style: TextStyle(
                          color: Color(0xff396f61),
                          fontWeight: FontWeight.normal,
                          fontSize: 35),
                    )),
                Container(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "Load photo pf your plant to knw it`s type with up to\n                              99% accurancy !",
                      style: TextStyle(
                          color: Color(0xff396f61),
                          fontWeight: FontWeight.bold,
                          fontSize: 8.5),
                    )),
                Container(
                  height: 20,
                ),
                InkWell(
                    onTap: () => Get.toNamed("/sign"),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: const Color(0xff739f6a)),
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        alignment: Alignment.center,
                        child: const InkWell(
                          child: Text(
                            "Sig in  ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ))),
                Container(
                  height: 15,
                ),
                InkWell(
                    onTap: () => Get.toNamed("/login"),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: const Color(0xffb8d295)),
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        alignment: Alignment.center,
                        child: const InkWell(
                          child: Text(
                            "Log in ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        )))
              ],
            )));
  }
}
