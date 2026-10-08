import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/image_controller.dart';
import 'controllers/plant_controller.dart';
import 'data/database_helper.dart';
import 'services/photo_storage.dart';
import 'services/plant_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final database = DatabaseHelper();
  final history = Get.put(
    ImageController(SqliteImageRepository(database)),
    permanent: true,
  );
  final auth = Get.put(
    AuthController(SqliteUserRepository(database), preferences, history),
    permanent: true,
  );
  Get.put(
    PlantController(PlantService(), LocalPhotoStorage(), auth, history),
    permanent: true,
  );
  runApp(const PlantFinderApp());
}
