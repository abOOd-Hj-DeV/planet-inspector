import 'dart:io';
import 'package:get/get.dart';
import 'package:plant_finder/controller/auth_controller.dart';
import 'package:plant_finder/model/image_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'plant_controller.dart';

final AuthController authController = Get.put(AuthController());

class ImageController extends GetxController {
  Database? _database;
  var images = <ImageModel>[].obs;
  var filteredImages = <ImageModel>[].obs; 
  var isLoading = true.obs; 

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
  String path = join(await getDatabasesPath(), 'images.db');

  if (await databaseExists(path)) {
    _database = await openDatabase(path);
  } else {
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE images(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            plantName TEXT, 
            description TEXT,
            imagePath TEXT,
            userId INTEGER,
            FOREIGN KEY (userId) REFERENCES users(id)
          )
        ''');
      },
    );
  }
  await loadImages(authController.userId.value); 
}


  void clearImages() {
    images.clear(); // مسح الصور القديمة
    filteredImages.clear(); // مسح الصور المفلترة القديمة
  }

 Future<void> loadImages(int userId) async { 
    isLoading.value = true; 
    final List<Map<String, dynamic>> maps = await _database!.query(
      'images',
      where: 'userId = ?', // تحميل الصور الخاصة بالمستخدم
      whereArgs: [userId],
    );
    
    images.value = maps.map((map) => ImageModel.fromMap(map)).toList();
    filteredImages.value = List.from(images); // تحديث filteredImages
    isLoading.value = false; 
  }

  
Future<void> pickImage(int userId) async { // إضافة userId كمعامل
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    String imagePath = pickedFile.path;

    final plantController = Get.find<PlantController>();
    await plantController.identifyPlant(File(imagePath));
    if (plantController.plantDetails.isNotEmpty) {
      String plantName = plantController.v.value;
      String description = plantController.description.value;
      await saveImage(plantName, description, imagePath, userId); // تمرير userId هنا
    } else {
      print('The uploaded image does not contain a plant.');
    }
  }
}

Future<void> saveImage(String plantName, String description, String imagePath, int userId) async { // إضافة userId كمعامل
  if (_database == null) {
    await _initializeDatabase();
  }

  await _database!.insert('images', {
    'plantName': plantName,
    'description': description,
    'imagePath': imagePath,
    'userId': userId // إضافة userId هنا
  });
  await loadImages(userId); // تحميل الصور بعد الحفظ
}

void searchImages(String query) {
  if (query.isEmpty) {
    filteredImages.value = images; 
  } else {
    filteredImages.value = images.where((image) => image.plantName.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

Future<void> resetDatabase() async {
  String path = join(await getDatabasesPath(), 'images.db');
  await deleteDatabase(path);
  await _initializeDatabase();
}

}
