import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final config = File('.dart_tool/package_config.json').absolute;
  final packages =
      (jsonDecode(await config.readAsString()) as Map)['packages'] as List;
  final flutter = packages.cast<Map>().singleWhere(
    (entry) => entry['name'] == 'flutter',
  );
  final sdk = Directory.fromUri(
    config.uri.resolve(flutter['rootUri'] as String),
  ).parent.parent;
  final fonts = Directory('${sdk.path}/bin/cache/artifacts/material_fonts');
  final roboto = FontLoader('Roboto');
  for (final weight in ['Regular', 'Medium', 'Bold', 'Black']) {
    roboto.addFont(_readFont(File('${fonts.path}/Roboto-$weight.ttf')));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(_readFont(File('${fonts.path}/MaterialIcons-Regular.otf')));
  await icons.load();
  await testMain();
}

Future<ByteData> _readFont(File file) async =>
    ByteData.sublistView(await file.readAsBytes());
