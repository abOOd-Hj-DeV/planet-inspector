import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:plant_finder/data/database_helper.dart';
import 'package:plant_finder/models/image_model.dart';
import 'package:plant_finder/models/user_model.dart';

void main() {
  sqfliteFfiInit();
  late Directory directory;
  late DatabaseHelper db;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('plant-db-test');
    db = DatabaseHelper(factory: databaseFactoryFfi, directory: directory.path);
  });
  tearDown(() async {
    await db.close();
    await directory.delete(recursive: true);
  });

  test('database initialization is safe for concurrent first reads', () async {
    final instances = await Future.wait([db.users, db.users]);
    expect(identical(instances.first, instances.last), isTrue);
    final users = SqliteUserRepository(db);
    final id = await users.insert(
      UserModel(
        fullName: 'Original',
        email: ' Original@Example.com ',
        password: 'legacy',
      ),
    );
    expect((await users.findByEmail('original@example.com'))!.id, id);
    expect((await users.findById(id))!.password, 'legacy');
  });
  test('legacy images.db migration retains rows and adds favorites', () async {
    final legacy = await databaseFactoryFfi.openDatabase(
      path.join(directory.path, 'images.db'),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) => db.execute(
          'CREATE TABLE images(id INTEGER PRIMARY KEY AUTOINCREMENT, plantName TEXT, description TEXT, imagePath TEXT, userId INTEGER)',
        ),
      ),
    );
    await legacy.insert('images', {
      'plantName': 'Rose',
      'description': 'Old result',
      'imagePath': 'old.jpg',
      'userId': 1,
    });
    await legacy.close();
    final images = SqliteImageRepository(db);
    expect((await images.load(1)).single.description, 'Old result');
    expect((await images.load(1)).single.isFavorite, isFalse);
    await images.setFavorite(1, 1, true);
    expect((await images.load(1)).single.isFavorite, isTrue);
  });
  test('all history mutations enforce user ownership in real SQLite', () async {
    final images = SqliteImageRepository(db);
    const record = ImageModel(
      plantName: 'Aloe',
      description: 'Green',
      imagePath: 'a.jpg',
    );
    await images.save(record, 1);
    await images.save(record, 2);
    final id = (await images.load(2)).single.id!;
    await images.setFavorite(id, 1, true);
    await images.delete(id, 1);
    expect((await images.load(2)).single.isFavorite, isFalse);
    await images.clear(1);
    expect(await images.load(1), isEmpty);
    expect(await images.load(2), hasLength(1));
    await db.close();
    expect(await SqliteImageRepository(db).load(2), hasLength(1));
  });
}
