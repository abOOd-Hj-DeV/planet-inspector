import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/image_model.dart';
import '../services/photo_storage.dart';
import '../services/plant_service.dart';
import 'auth_controller.dart';
import 'image_controller.dart';

class PlantController extends GetxController {
  PlantController(
    this.service,
    this.storage,
    this.auth,
    this.history, {
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();
  final PlantIdentifier service;
  final PhotoStorage storage;
  final AuthController auth;
  final ImageController history;
  final ImagePicker _picker;
  final isBusy = false.obs;

  Future<ImageModel?> pickAndIdentify(ImageSource source) async {
    if (isBusy.value) return null;
    final userId = auth.userId.value;
    if (userId <= 0) throw const AuthException('Please log in first.');
    isBusy.value = true;
    try {
      final photo = await _picker.pickImage(source: source, maxWidth: 1600);
      if (photo == null) return null;
      final bytes = await LocalPhotoStorage.prepare(await photo.readAsBytes());
      final result = await service.identify(bytes, 'plant.jpg');
      if (auth.userId.value != userId) return null;
      final imagePath = await storage.save(bytes, photo.name);
      final record = ImageModel(
        plantName: result.name,
        description: result.description,
        imagePath: imagePath,
      );
      await history.repository.save(record, userId);
      if (auth.userId.value == userId) await history.loadImages(userId);
      return auth.userId.value == userId ? record : null;
    } finally {
      isBusy.value = false;
    }
  }
}
