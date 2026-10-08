import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_finder/controller/auth_controller.dart';
import 'package:plant_finder/controller/image_controller.dart';
import 'package:plant_finder/controller/plant_controller.dart';

PlantController plantController = Get.put(PlantController());
ImageController imageController = Get.put(ImageController());
final AuthController authController = Get.find();

class A extends StatelessWidget {
  const A({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 100,
          height: MediaQuery.of(context).size.height * 100,
          child: Image.asset(
            "img/back.png",
            fit: BoxFit.cover,
          ),
        ),
        Center(
            child: Column(
          children: [
            SizedBox(
              height: 210,
            ),
            InkWell(
                onTap: () async {
                  XFile? xFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (xFile != null) {
                    File imageFile = File(xFile.path);

                    // إظهار دائرة التحميل
                    Get.dialog(const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false);

                    await plantController.identifyPlant(imageFile);

                    // إغلاق دائرة التحميل
                    Get.back();

                    // عرض المعلومات في AlertDialog
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: const Color(0xFFf6f5e9),
                        title: Text(
                          plantController.v.value.isNotEmpty
                              ? plantController.v.value
                              : 'Unknown Plant',
                          style: const TextStyle(color: Color(0xff739f6a)),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.file(
                                imageFile,
                                fit: BoxFit.contain,
                                height: 200,
                                width: double.infinity,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                plantController.description.value.isNotEmpty
                                    ? plantController.description.value
                                    : 'That is not a plant',
                                textAlign: TextAlign.start,
                                style:
                                    const TextStyle(color: Color(0xff739f6a)),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // إعادة تعيين القيم
                              plantController.v.value = '';
                              plantController.description.value = '';
                              plantController.plantDetails.value = {};
                              Get.back(); // إغلاق الDialog
                            },
                            child: const Text('Close',
                                style: TextStyle(color: Color(0xffeb9d65))),
                          ),
                        ],
                      ),
                    );
                    await imageController.saveImage(
                      plantController.v.value,
                      plantController.description.value,
                      imageFile.path,
                      authController.userId.value
                    );
                  }
                },
                child: Container(
                  alignment:Alignment.center,
                  width: 150,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf6f5e9), // تغيير اللون إلى الأبيض
                    border: Border.all(
                        color: Color(0xff739f6a),
                        width: 4), // إضافة إطار أخضر غامق
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Album',
                    style: TextStyle(
                        color:
                            Color(0xff739f6a)), // تغيير لون النص إلى أخضر غامق
                  ),
                )),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                XFile? xFile =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (xFile != null) {
                  File imageFile = File(xFile.path);

                  // إظهار دائرة التحميل
                  Get.dialog(const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false);

                  // ضغط الصورة
                  Uint8List imageBytes = await imageFile.readAsBytes();
                  img.Image? originalImage = img.decodeImage(imageBytes);
                  img.Image? resizedImage = img.copyResize(originalImage!,
                      width: 800); // تغيير العرض حسب الحاجة
                  Uint8List compressedImageBytes = img.encodeJpg(resizedImage,
                      quality: 85); // ضبط الجودة حسب الحاجة

                  // حفظ الصورة المضغوطة إلى ملف مؤقت
                  final tempDir = await getTemporaryDirectory();
                  final compressedImageFile =
                      File('${tempDir.path}/compressed_image.jpg');
                  await compressedImageFile.writeAsBytes(compressedImageBytes);

                  // التعرف على النبات بالصورة المضغوطة
                  await plantController.identifyPlant(compressedImageFile);

                  // إغلاق دائرة التحميل
                  Get.back();

                  // عرض المعلومات في AlertDialog
                  Get.dialog(
                    AlertDialog(
                      backgroundColor: const Color(0xFFf6f5e9),
                      title: Text(
                        plantController.v.value.isNotEmpty
                            ? plantController.v.value
                            : 'Unknown Plant',
                        style: const TextStyle(color: Color(0xff739f6a)),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.file(
                              compressedImageFile,
                              fit: BoxFit.contain,
                              height: 200,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              plantController.description.value.isNotEmpty
                                  ? plantController.description.value
                                  : 'That is not a plant',
                              textAlign: TextAlign.start,
                              style: const TextStyle(color: Color(0xff739f6a)),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // إعادة تعيين القيم
                            plantController.v.value = '';
                            plantController.description.value = '';
                            plantController.plantDetails.value = {};
                            Get.back(); // إغلاق الDialog
                          },
                          child: const Text('Close',
                              style: TextStyle(color: Color(0xffeb9d65))),
                        ),
                      ],
                    ),
                  );
                  // حفظ الصورة بعد عرض المعلومات
                  await imageController.saveImage(
                    plantController.v.value,
                    plantController.description.value,
                    compressedImageFile.path,
                    authController.userId.value
                  );
                }
              },
              child: Container(
                  alignment:Alignment.center,
                  width: 150,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf6f5e9), // تغيير اللون إلى الأبيض
                    border: Border.all(
                        color: Color(0xff739f6a),
                        width: 4), // إضافة إطار أخضر غامق
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Camera',
                    style: TextStyle(
                        color:
                            Color(0xff739f6a)), // تغيير لون النص إلى أخضر غامق
                  ),
                )
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => Get.toNamed("/history"),
              child: Container(
                  alignment:Alignment.center,
                  width: 150,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf6f5e9), // تغيير اللون إلى الأبيض
                    border: Border.all(
                        color: Color(0xff739f6a),
                        width: 4), // إضافة إطار أخضر غامق
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Go to history',
                    style: TextStyle(
                        color:
                            Color(0xff739f6a)), // تغيير لون النص إلى أخضر غامق
                  ),
                )
            )
          ],
        ))
      ],
    ));
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);
    if (xFile != null) {
      File imageFile = File(xFile.path);
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      await plantController.identifyPlant(imageFile);

      String plantName = plantController.v.value;
      String description = plantController.description.value;

      // عرض المعلومات في AlertDialog
      Get.back(); // اغلق دائرة التحميل
      Get.defaultDialog(
        title: "Plant Information",
        content: Column(
          children: [
            Text('Plant Name: $plantName'),
            Text('Description: $description'),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(); // اغلق AlertDialog
          },
          child: Text('OK'),
        ),
      );
      await imageController.saveImage(plantName, description, imageFile.path,authController.userId.value);

      // إعادة تعيين القيم
      plantController.v.value = '';
      plantController.description.value = '';
      plantController.plantDetails.value = {};
    }
  }
}
