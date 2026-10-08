import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_finder/controller/image_controller.dart';
import 'package:plant_finder/controller/plant_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    PlantController plantController = Get.put(PlantController());
    final ImageController imageController = Get.put(ImageController());

    // ignore: deprecated_member_use
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 25),
        alignment: Alignment.center,
        color: const Color(0xFFf6f5e9),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (imageController.images.isEmpty) {
                  return const Center(child: Text("No images found."));
                } else {
                  return ListView.builder(
                    itemCount: imageController.images.length,
                    itemBuilder: (BuildContext context, i) {
                      final image = imageController.images[i];
                      final isPlantImage = image.description.isNotEmpty;

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
                                        File(image.imagePath),
                                        fit: BoxFit.contain,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          image.description.isNotEmpty
                                              ? image.description
                                              : 'That is not plant',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Color(0xff739f6a))),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255,
                                                  82,
                                                  146,
                                                  106)), // لون النص الأساسي
                                          children: [
                                            TextSpan(
                                                text:
                                                    "Farmability in desert areas: ",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black)), // لون النص الأساسي
                                            TextSpan(
                                              text: plantController.allowPlant
                                                      .contains(image.plantName)
                                                  ? 'ABLE'
                                                  : 'NOT ABLE',
                                              style: TextStyle(
                                                color: plantController
                                                        .allowPlant
                                                        .contains(
                                                            image.plantName)
                                                    ? Colors.green
                                                    : Colors
                                                        .red, // اللون حسب الحالة
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
                                        style: TextStyle(
                                            color: Color(0xffeb9d65))),
                                  ),
                                ],
                              ),
                            );
                          },
                          child:Stack(
  children: [
    Container(
      width: MediaQuery.of(context).size.width * 1, // عرض مرن
      height: MediaQuery.of(context).size.height * 0.2, // ارتفاع مرن
      decoration: BoxDecoration(
        color: const Color(0xff306e63),
        borderRadius: BorderRadius.circular(9.5),
      ),
      margin: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(9.5),
          color: const Color(0xfff88e00),
        ),
        margin: const EdgeInsets.all(6),
        child: Container(
          margin: const EdgeInsets.all(6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.5),
              color: const Color(0xffec9d65),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0), // إضافة مسافة داخلية
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isPlantImage ? image.plantName : "that is not a plant !!",
                      style: const TextStyle(
                        color: Color(0xFFf6f5e9),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      maxLines: 3, // تحديد الحد الأقصى لعدد الأسطر
                      overflow: TextOverflow.ellipsis, // إضافة ثلاث نقاط في نهاية النص إذا كان طويلًا
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(image.imagePath),
                      width: MediaQuery.of(context).size.width * 0.30, // عرض مرن للصورة
                      height: MediaQuery.of(context).size.height * 0.4, // ارتفاع مرن للصورة
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ],
));

                    },
                  );
                }
              }),
            ),
            InkWell(
              onTap: () async {
                XFile? xFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (xFile != null) {
                  File imageFile = File(xFile.path);
                  Get.dialog(const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false);
                  await plantController.identifyPlant(imageFile);

                  print('Plant Name: ${plantController.v.value}');
                  print('Description: ${plantController.description.value}');
                  await imageController.saveImage(
                      plantController.v.value,
                      plantController.description.value,
                      imageFile.path,
                      authController.userId.value);

                  plantController.v.value = '';
                  plantController.description.value = '';
                  plantController.plantDetails.value = {};

                  Get.back();
                }
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Image.asset("img/upload.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
