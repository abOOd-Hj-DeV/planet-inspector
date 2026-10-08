import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_finder/controllers/auth_controller.dart';
import 'package:plant_finder/controllers/image_controller.dart';
import '../support/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthController auth;
  late FakeUsers users;
  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    users = FakeUsers();
    auth = AuthController(users, prefs, ImageController(FakeImages()));
  });
  test(
    'registration normalizes email and rejects duplicate with a different password',
    () async {
      await auth.register(' Explorer ', ' EXPLORER@example.com ', 'first');
      expect(users.users.single.fullName, 'Explorer');
      expect(users.users.single.email, 'explorer@example.com');
      await expectLater(
        auth.register('Other', 'explorer@example.com', 'second'),
        throwsA(isA<AuthException>()),
      );
      expect(users.users, hasLength(1));
    },
  );
  test('failed login does not persist a session', () async {
    await auth.register('Explorer', 'e@example.com', 'secret');
    await expectLater(
      auth.login('e@example.com', 'wrong'),
      throwsA(isA<AuthException>()),
    );
    expect(auth.isLoggedIn.value, isFalse);
    expect(prefs.getInt('userId'), isNull);
  });
  test(
    'login, restart and logout preserve and clear the correct session',
    () async {
      await auth.register('Explorer', 'e@example.com', 'secret');
      await auth.login(' E@example.com ', 'secret');
      expect(prefs.getInt('userId'), 1);
      final restored = AuthController(
        users,
        prefs,
        ImageController(FakeImages()),
      );
      await restored.restoreSession();
      expect(restored.userId.value, 1);
      expect(restored.fullName.value, 'Explorer');
      await restored.logout();
      expect(restored.userId.value, 0);
      expect(restored.isLoggedIn.value, isFalse);
      expect(prefs.getInt('userId'), isNull);
      expect(restored.history.images, isEmpty);
    },
  );
  test('stale session for a deleted user is discarded', () async {
    await prefs.setInt('userId', 99);
    await prefs.setBool('isLoggedIn', true);
    await auth.restoreSession();
    expect(auth.isLoggedIn.value, isFalse);
    expect(prefs.getBool('isLoggedIn'), isNull);
  });
}
