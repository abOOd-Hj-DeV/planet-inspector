import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/plant_result.dart';

abstract class PlantIdentifier {
  Future<PlantResult> identify(Uint8List bytes, String filename);
}

class PlantServiceException implements Exception {
  const PlantServiceException(this.message);
  final String message;
  @override
  String toString() => message;
}

class PlantService implements PlantIdentifier {
  PlantService({
    http.Client? client,
    String? baseUrl,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client(),
       _baseUrl =
           baseUrl ??
           const String.fromEnvironment(
             'PLANT_API_URL',
             defaultValue: 'http://192.168.1.110:5000',
           );
  final http.Client _client;
  final String _baseUrl;
  final Duration timeout;

  @override
  Future<PlantResult> identify(Uint8List bytes, String filename) async {
    try {
      final uri = Uri.parse(
        '${_baseUrl.replaceAll(RegExp(r'/+$'), '')}/identify_plant',
      );
      if (!uri.hasAuthority || !['http', 'https'].contains(uri.scheme)) {
        throw const PlantServiceException('Set a valid PLANT_API_URL.');
      }
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes('image', bytes, filename: filename),
        );
      final response = await _client.send(request).timeout(timeout);
      final body = await response.stream.bytesToString().timeout(timeout);
      if (response.statusCode != 200) {
        throw const PlantServiceException(
          'The plant service could not identify this photo. Please retry.',
        );
      }
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) throw const FormatException();
      return PlantResult.fromJson(decoded);
    } on TimeoutException {
      throw const PlantServiceException(
        'The plant service timed out. Please retry.',
      );
    } on FormatException {
      throw const PlantServiceException(
        'No plant was identified. Please choose another photo.',
      );
    } on PlantServiceException {
      rethrow;
    } catch (_) {
      throw const PlantServiceException(
        'Cannot connect to the plant service. Check your connection and API address.',
      );
    }
  }

  void close() => _client.close();
}
