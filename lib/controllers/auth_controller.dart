import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories.dart';
import '../models/user_model.dart';
import 'image_controller.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

class AuthController extends GetxController {
  AuthController(this.users, this.preferences, this.history);
  final UserRepository users;
  final SharedPreferences preferences;
  final ImageController history;
  final userId = 0.obs;
  final isLoggedIn = false.obs;
  final fullName = ''.obs;

  Future<void> restoreSession() async {
    final id = preferences.getInt('userId') ?? 0;
    final user = preferences.getBool('isLoggedIn') == true && id > 0
        ? await users.findById(id)
        : null;
    if (user == null) {
      await logout();
      return;
    }
    userId.value = user.id!;
    fullName.value = user.fullName;
    isLoggedIn.value = true;
    await history.loadImages(user.id!);
  }

  Future<void> register(String name, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (await users.findByEmail(normalizedEmail) != null) {
      throw const AuthException('An account already exists with this email.');
    }
    await users.insert(
      UserModel(
        fullName: name.trim(),
        email: normalizedEmail,
        password: password,
      ),
    );
  }

  Future<void> login(String email, String password) async {
    final user = await users.findByEmail(email.trim().toLowerCase());
    if (user == null || user.password != password) {
      throw const AuthException('Invalid email or password.');
    }
    await preferences.setInt('userId', user.id!);
    await preferences.setBool('isLoggedIn', true);
    userId.value = user.id!;
    fullName.value = user.fullName;
    isLoggedIn.value = true;
    history.clearImages();
    await history.loadImages(user.id!);
  }

  Future<void> logout() async {
    await preferences.remove('userId');
    await preferences.remove('isLoggedIn');
    userId.value = 0;
    fullName.value = '';
    isLoggedIn.value = false;
    history.clearImages();
  }
}
