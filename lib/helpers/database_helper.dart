import 'package:plant_finder/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT, email TEXT, password TEXT);
          CREATE TABLE images(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            plantName TEXT, 
            description TEXT,
            imagePath TEXT,
            userId INTEGER,
            FOREIGN KEY (userId) REFERENCES users(id)
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel(
        id: maps.first['id'],
        fullName: maps.first['fullName'],
        email: maps.first['email'],
        password: maps.first['password'],
      );
    }
    return null;
  }
}
