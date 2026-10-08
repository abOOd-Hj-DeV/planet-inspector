import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_finder/controller/auth_controller.dart';
import 'package:plant_finder/controller/image_controller.dart';
import 'package:plant_finder/controller/plant_controller.dart';

PlantController plantController = Get.put(PlantController());
ImageController controller = Get.put(ImageController());
final AuthController authController = Get.find();

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        color: const Color(0xFFf6f5e9),
        child: ListView(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    authController.logout();
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(8.0), 
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xffeb9d65),
                    ),
                  ),
                ),
                const Spacer(), 
                InkWell(
                  onTap: () => controller.resetDatabase(),
                  child: Container(
                    padding: const EdgeInsets.all(8.0), 
                    child: const Text(
                      "Clear History",
                      style: TextStyle(color: Color(0xffeb9d65), fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 60, bottom: 40),
              alignment: Alignment.center,
              child: const Text(
                "History",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color(0xff739f6a)),
              ),
            ),
            Container(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Form(
                child: TextFormField(
                  onChanged: (value) {
                    controller.searchImages(value);
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Color(0xfff6f5e9),
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
                    hintText: "Search history",
                    hintStyle: const TextStyle(
                      color: Color(0xFFf6f5e9),
                      fontSize: 13,
                    ),
                    fillColor: const Color(0xff739f6a),
                    filled: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  ),
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 65),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff739f6a),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
              child: SizedBox(
                height: 230,
                child: Obx(() {
                  return GridView.count(
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 10.0,
                    crossAxisCount: 2,
                    children: List.generate(controller.filteredImages.length,
                        (index) {
                      final image = controller.filteredImages[index];
                      return InkWell(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              backgroundColor: const Color(0xFFf6f5e9),
                              title: Text(
                                image.plantName,
                                style:
                                    const TextStyle(color: Color(0xff739f6a)),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.file(
                                      File(image
                                          .imagePath), 
                                      fit: BoxFit
                                          .contain, 
                                      height: 200, 
                                      width:
                                          double.infinity, 
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        image.description.isNotEmpty
                                            ? image.description
                                            : 'That is not plant', 
                                        textAlign:
                                            TextAlign.start, 
                                        style: const TextStyle(
                                            color: Color(0xff739f6a))),
                                            RichText(
  text: TextSpan(
    style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 82, 146, 106)), // لون النص الأساسي
    children: [
      TextSpan(text: "Farmability in desert areas: ", style: TextStyle(color: Colors.black)), // لون النص الأساسي
      TextSpan(
        text: plantController.allowPlant.contains(image.plantName) ? 'ABLE' : 'NOT ABLE',
        style: TextStyle(
          color: plantController.allowPlant.contains(image.plantName) ? Colors.green : Colors.red, // اللون حسب الحالة
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
)

                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back(); 
                                  },
                                  child: const Text('Close',
                                      style:
                                          TextStyle(color: Color(0xffeb9d65))),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(image
                                  .imagePath), 
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
            InkWell(
              onTap: () => Get.toNamed("/mainp")?.then((_) async {

                controller.loadImages(authController.userId.value); 
              }),
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: const Text(
                  "MAKE NEW SEARCH NOW !",
                  style: TextStyle(color: Color(0xffeb9d65), fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

      
}
