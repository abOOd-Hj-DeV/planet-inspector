import 'package:flutter_test/flutter_test.dart';
import 'package:plant_finder/app/validators.dart';
import 'package:plant_finder/models/image_model.dart';
import 'package:plant_finder/models/plant_result.dart';

void main() {
  test('required fields reject blank values', () {
    expect(Validators.required(null), isNotNull);
    expect(Validators.required('  '), isNotNull);
    expect(Validators.required('Explorer'), isNull);
  });
  test('email validates trimmed input', () {
    expect(Validators.email(' person@example.com '), isNull);
    for (final invalid in ['', 'a', 'a@', '@example.com', 'a b@example.com']) {
      expect(Validators.email(invalid), isNotNull);
    }
  });
  test('password confirmation checks all fields', () {
    expect(Validators.confirmPassword('', 'secret'), isNotNull);
    expect(Validators.confirmPassword('wrong', 'secret'), isNotNull);
    expect(Validators.confirmPassword('secret', 'secret'), isNull);
  });
  test('legacy image rows without favorite column remain readable', () {
    expect(
      ImageModel.fromMap({
        'id': 1,
        'plantName': 'Rose',
        'description': '',
        'imagePath': 'photo.jpg',
      }).isFavorite,
      isFalse,
    );
  });
  test('plant parsing handles absent description', () {
    expect(
      PlantResult.fromJson({'name': 'Rose'}).description,
      'No description available.',
    );
  });
}
