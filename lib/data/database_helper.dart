import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/image_model.dart';
import '../models/user_model.dart';
import 'repositories.dart';

class DatabaseHelper {
  DatabaseHelper({DatabaseFactory? factory, this.directory})
    : _factory = factory ?? databaseFactory;

  final DatabaseFactory _factory;
  final String? directory;
  Future<Database>? _users;
  Future<Database>? _images;

  Future<String> _path(String name) async =>
      path.join(directory ?? await _factory.getDatabasesPath(), name);

  Future<Database> get users => _users ??= _openUsers();
  Future<Database> get images => _images ??= _openImages();

  Future<Database> _openUsers() async => _factory.openDatabase(
    await _path('app_database.db'),
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY '
          'AUTOINCREMENT, fullName TEXT, email TEXT, password TEXT)',
        );
      },
    ),
  );

  Future<Database> _openImages() async => _factory.openDatabase(
    await _path('images.db'),
    options: OpenDatabaseOptions(
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE images(id INTEGER PRIMARY KEY '
          'AUTOINCREMENT, plantName TEXT, description TEXT, '
          'imagePath TEXT, userId INTEGER, '
          'isFavorite INTEGER NOT NULL DEFAULT 0)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE images ADD COLUMN '
            'isFavorite INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    ),
  );

  Future<void> close() async {
    if (_users != null) await (await _users!).close();
    if (_images != null) await (await _images!).close();
    _users = null;
    _images = null;
  }
}

class SqliteUserRepository implements UserRepository {
  SqliteUserRepository(this.database);
  final DatabaseHelper database;

  UserModel _fromMap(Map<String, Object?> map) => UserModel(
    id: map['id'] as int,
    fullName: map['fullName'] as String,
    email: map['email'] as String,
    password: map['password'] as String,
  );

  @override
  Future<UserModel?> findByEmail(String email) async {
    final rows = await (await database.users).query(
      'users',
      where: 'LOWER(TRIM(email)) = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    return rows.isEmpty ? null : _fromMap(rows.first);
  }

  @override
  Future<UserModel?> findById(int id) async {
    final rows = await (await database.users).query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : _fromMap(rows.first);
  }

  @override
  Future<int> insert(UserModel user) async =>
      (await database.users).insert('users', user.toMap());
}

class SqliteImageRepository implements ImageRepository {
  SqliteImageRepository(this.database);
  final DatabaseHelper database;

  @override
  Future<List<ImageModel>> load(int userId) async {
    final rows = await (await database.images).query(
      'images',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return rows.map(ImageModel.fromMap).toList();
  }

  @override
  Future<void> save(ImageModel image, int userId) async {
    await (await database.images).insert('images', {
      'plantName': image.plantName,
      'description': image.description,
      'imagePath': image.imagePath,
      'userId': userId,
      'isFavorite': image.isFavorite ? 1 : 0,
    });
  }

  @override
  Future<void> clear(int userId) async {
    await (await database.images).delete(
      'images',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> delete(int id, int userId) async {
    await (await database.images).delete(
      'images',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  @override
  Future<void> setFavorite(int id, int userId, bool favorite) async {
    await (await database.images).update(
      'images',
      {'isFavorite': favorite ? 1 : 0},
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }
}
