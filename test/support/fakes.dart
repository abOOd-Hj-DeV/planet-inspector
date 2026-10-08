import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_finder/controllers/auth_controller.dart';
import 'package:plant_finder/controllers/image_controller.dart';
import 'package:plant_finder/controllers/plant_controller.dart';
import 'package:plant_finder/data/repositories.dart';
import 'package:plant_finder/models/image_model.dart';
import 'package:plant_finder/models/plant_result.dart';
import 'package:plant_finder/models/user_model.dart';
import 'package:plant_finder/services/photo_storage.dart';
import 'package:plant_finder/services/plant_service.dart';

class FakeUsers implements UserRepository {
  final users = <UserModel>[];
  @override
  Future<UserModel?> findByEmail(String email) async => users.firstWhereOrNull(
    (user) => user.email.trim().toLowerCase() == email.trim().toLowerCase(),
  );
  @override
  Future<UserModel?> findById(int id) async =>
      users.firstWhereOrNull((user) => user.id == id);
  @override
  Future<int> insert(UserModel user) async {
    final id = users.length + 1;
    users.add(
      UserModel(
        id: id,
        fullName: user.fullName,
        email: user.email,
        password: user.password,
      ),
    );
    return id;
  }
}

class FakeImages implements ImageRepository {
  final rows = <int, List<ImageModel>>{};
  bool failLoad = false;
  int nextId = 1;
  @override
  Future<List<ImageModel>> load(int userId) async {
    if (failLoad) throw StateError('unavailable');
    return List.of(rows[userId] ?? []);
  }

  @override
  Future<void> save(ImageModel image, int userId) async {
    (rows[userId] ??= []).add(
      ImageModel(
        id: nextId++,
        plantName: image.plantName,
        description: image.description,
        imagePath: image.imagePath,
        isFavorite: image.isFavorite,
      ),
    );
  }

  @override
  Future<void> clear(int userId) async {
    rows[userId] = [];
  }

  @override
  Future<void> delete(int id, int userId) async {
    rows[userId]?.removeWhere((row) => row.id == id);
  }

  @override
  Future<void> setFavorite(int id, int userId, bool favorite) async {
    final rowsForUser = rows[userId] ?? [];
    final index = rowsForUser.indexWhere((row) => row.id == id);
    if (index < 0) return;
    final row = rowsForUser[index];
    rowsForUser[index] = ImageModel(
      id: row.id,
      plantName: row.plantName,
      description: row.description,
      imagePath: row.imagePath,
      isFavorite: favorite,
    );
  }
}

class FakeIdentifier implements PlantIdentifier {
  bool fail = false;
  int calls = 0;
  @override
  Future<PlantResult> identify(Uint8List bytes, String filename) async {
    calls++;
    if (fail) throw const PlantServiceException('Service unavailable');
    return const PlantResult(
      name: 'Dracaena fragrans',
      description: 'A tropical evergreen plant.',
    );
  }
}

class FakeStorage implements PhotoStorage {
  int saves = 0;
  @override
  Future<String> save(Uint8List bytes, String filename) async {
    saves++;
    return '/saved/photo-$saves.jpg';
  }
}

class FakePicker extends ImagePicker {
  XFile? photo;
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async => photo;
}

Future<AuthController> setupControllers({bool loggedIn = true}) async {
  Get.testMode = true;
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final history = Get.put(ImageController(FakeImages()), permanent: true);
  final users = FakeUsers();
  final auth = Get.put(AuthController(users, prefs, history), permanent: true);
  await auth.register(
    'Plant Explorer',
    'explorer@example.com',
    'test-password',
  );
  if (loggedIn) await auth.login('explorer@example.com', 'test-password');
  Get.put(
    PlantController(
      FakeIdentifier(),
      FakeStorage(),
      auth,
      history,
      picker: FakePicker(),
    ),
    permanent: true,
  );
  return auth;
}
