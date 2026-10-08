import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:plant_finder/services/plant_service.dart';

void main() {
  final bytes = Uint8List.fromList([1, 2, 3]);
  test(
    'posts the expected multipart image and parses the legacy API response',
    () async {
      final service = PlantService(
        baseUrl: 'https://plants.example/',
        client: MockClient((request) async {
          expect(
            request.url.toString(),
            'https://plants.example/identify_plant',
          );
          expect(request.method, 'POST');
          expect(
            request.headers['content-type'],
            contains('multipart/form-data'),
          );
          expect(request.body, contains('name="image"; filename="plant.jpg"'));
          return http.Response(
            '{"name":"Rose","description":{"value":"A flower"}}',
            200,
          );
        }),
      );
      addTearDown(service.close);
      final result = await service.identify(bytes, 'plant.jpg');
      expect(result.name, 'Rose');
      expect(result.description, 'A flower');
    },
  );
  for (final body in ['{}', '{"name":""}', 'invalid json', '[]']) {
    test('rejects invalid/non-plant response: $body', () async {
      final service = PlantService(
        client: MockClient((_) async => http.Response(body, 200)),
      );
      addTearDown(service.close);
      await expectLater(
        service.identify(bytes, 'plant.jpg'),
        throwsA(isA<PlantServiceException>()),
      );
    });
  }
  test(
    'supports a plain description and supplies a missing description',
    () async {
      final service = PlantService(
        client: MockClient(
          (_) async =>
              http.Response('{"name":"Aloe","description":"Green"}', 200),
        ),
      );
      addTearDown(service.close);
      expect((await service.identify(bytes, 'a.jpg')).description, 'Green');
    },
  );
  test('non-JSON HTTP error is handled without leaking an exception', () async {
    final service = PlantService(
      client: MockClient((_) async => http.Response('<h1>Down</h1>', 503)),
    );
    addTearDown(service.close);
    await expectLater(
      service.identify(bytes, 'a.jpg'),
      throwsA(isA<PlantServiceException>()),
    );
  });
  test('network failure and timeout produce useful errors', () async {
    final offline = PlantService(
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    final slow = PlantService(
      timeout: const Duration(milliseconds: 1),
      client: MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return http.Response('{}', 200);
      }),
    );
    addTearDown(offline.close);
    addTearDown(slow.close);
    await expectLater(
      offline.identify(bytes, 'a.jpg'),
      throwsA(isA<PlantServiceException>()),
    );
    await expectLater(
      slow.identify(bytes, 'a.jpg'),
      throwsA(isA<PlantServiceException>()),
    );
  });
}
