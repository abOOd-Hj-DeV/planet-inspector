import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_finder/controllers/auth_controller.dart';
import 'package:plant_finder/controllers/image_controller.dart';
import 'package:plant_finder/controllers/plant_controller.dart';
import 'package:plant_finder/services/plant_service.dart';
import '../support/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PlantController plant;
  late FakeIdentifier service;
  late FakePicker picker;
  late FakeStorage storage;
  late ImageController history;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    history = ImageController(FakeImages());
    final auth = AuthController(
      FakeUsers(),
      await SharedPreferences.getInstance(),
      history,
    );
    await auth.register('Explorer', 'e@example.com', 'test');
    await auth.login('e@example.com', 'test');
    service = FakeIdentifier();
    picker = FakePicker();
    storage = FakeStorage();
    picker.photo = XFile.fromData(
      image.encodePng(image.Image(width: 8, height: 8)),
      name: 'plant.png',
    );
    plant = PlantController(service, storage, auth, history, picker: picker);
  });
  test('success persists a durable photo and result exactly once', () async {
    final result = await plant.pickAndIdentify(ImageSource.camera);
    expect(result!.plantName, 'Dracaena fragrans');
    expect(history.images.single.imagePath, '/saved/photo-1.jpg');
    expect(service.calls, 1);
    expect(storage.saves, 1);
    expect(plant.isBusy.value, isFalse);
  });
  test(
    'API failure never saves a stale/failed result and resets busy state',
    () async {
      service.fail = true;
      await expectLater(
        plant.pickAndIdentify(ImageSource.gallery),
        throwsA(isA<PlantServiceException>()),
      );
      expect(history.images, isEmpty);
      expect(storage.saves, 0);
      expect(plant.isBusy.value, isFalse);
    },
  );
  test(
    'canceling the picker does not call the service or save a photo',
    () async {
      picker.photo = null;
      expect(await plant.pickAndIdentify(ImageSource.gallery), isNull);
      expect(service.calls, 0);
      expect(storage.saves, 0);
      expect(plant.isBusy.value, isFalse);
    },
  );
  test('invalid photos fail safely before network or storage', () async {
    picker.photo = XFile.fromData(
      image.encodePng(image.Image(width: 1, height: 1)).sublist(0, 4),
      name: 'broken.jpg',
    );
    await expectLater(
      plant.pickAndIdentify(ImageSource.gallery),
      throwsA(isA<FormatException>()),
    );
    expect(service.calls, 0);
    expect(plant.isBusy.value, isFalse);
  });
}
