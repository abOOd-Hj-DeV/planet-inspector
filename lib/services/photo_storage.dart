import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract class PhotoStorage {
  Future<String> save(Uint8List bytes, String filename);
}

Uint8List _compress(Uint8List bytes) {
  image.Image? decoded;
  try {
    decoded = image.decodeImage(bytes);
  } catch (_) {
    throw const FormatException('Choose a valid image file.');
  }
  if (decoded == null) {
    throw const FormatException('Choose a valid image file.');
  }
  final oriented = image.bakeOrientation(decoded);
  final resized = oriented.width > 800
      ? image.copyResize(oriented, width: 800)
      : oriented;
  return image.encodeJpg(resized, quality: 85);
}

class LocalPhotoStorage implements PhotoStorage {
  static Future<Uint8List> prepare(Uint8List bytes) =>
      compute(_compress, bytes);

  @override
  Future<String> save(Uint8List bytes, String filename) async {
    final root = await getApplicationDocumentsDirectory();
    final directory = await Directory(
      path.join(root.path, 'plant_photos'),
    ).create(recursive: true);
    final file = File(
      path.join(directory.path, '${DateTime.now().microsecondsSinceEpoch}.jpg'),
    );
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
