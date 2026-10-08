import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:plant_finder/app/app.dart';
import 'package:plant_finder/app/app_theme.dart';
import 'package:plant_finder/app/routes.dart';
import 'package:plant_finder/controllers/image_controller.dart';
import 'package:plant_finder/models/image_model.dart';
import 'package:plant_finder/screens/auth_screen.dart';
import 'package:plant_finder/screens/history_screen.dart';
import 'package:plant_finder/screens/home_screen.dart';
import 'package:plant_finder/screens/results_screen.dart';
import 'package:plant_finder/screens/welcome_screen.dart';
import '../support/fakes.dart';

Future<void> mount(
  WidgetTester tester,
  Widget screen, {
  double scale = 1,
  double keyboard = 0,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: appTheme,
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(320, 568),
          textScaler: TextScaler.linear(scale),
          viewInsets: EdgeInsets.only(bottom: keyboard),
        ),
        child: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    await setupControllers();
  });
  tearDown(Get.reset);
  testWidgets('registration displays every required validation error at once', (
    tester,
  ) async {
    await mount(tester, const AuthScreen(isRegister: true));
    await tester.scrollUntilVisible(
      find.widgetWithText(ElevatedButton, 'Sign Up'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required.'), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });
  testWidgets('login invalid email and password visibility work', (
    tester,
  ) async {
    await mount(tester, const AuthScreen());
    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.enterText(find.byType(TextFormField).last, 'secret');
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField).last).enabled,
      isTrue,
    );
    expect(find.byTooltip('Hide password'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
  });
  testWidgets(
    'welcome, sign-up link, login and logout navigate without missing controllers',
    (tester) async {
      await setupLoggedOut();
      await tester.pumpWidget(
        GetMaterialApp(
          theme: appTheme,
          initialRoute: AppRoutes.welcome,
          getPages: AppRoutes.pages,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Already registered? Log in here'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'explorer@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'test-password');
      await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pumpAndSettle();
      expect(find.text('Go to history'), findsOneWidget);
      await tester.tap(find.byTooltip('Log out'));
      await tester.pumpAndSettle();
      expect(find.text('PLANT\nFINDER'), findsOneWidget);
      expect(Get.isRegistered<ImageController>(), isTrue);
    },
  );
  testWidgets('splash restores an existing session once', (tester) async {
    await tester.pumpWidget(const PlantFinderApp());
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('Go to history'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('protected routes redirect a logged-out user', (tester) async {
    await setupLoggedOut();
    await tester.pumpWidget(
      GetMaterialApp(
        theme: appTheme,
        initialRoute: AppRoutes.history,
        getPages: AppRoutes.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('PLANT\nFINDER'), findsOneWidget);
    expect(find.text('Search history'), findsNothing);
  });
  testWidgets(
    'history search, favorites, delete cancellation and confirmation work',
    (tester) async {
      final history = Get.find<ImageController>();
      await history.repository.save(
        const ImageModel(
          plantName: 'Rose',
          description: 'A flower',
          imagePath: '/missing.jpg',
        ),
        1,
      );
      await history.loadImages(1);
      await mount(tester, const HistoryScreen());
      await tester.tap(find.byTooltip('Add favorite'));
      await tester.pumpAndSettle();
      expect(history.images.single.isFavorite, isTrue);
      await tester.tap(find.text('Favorites'));
      await tester.enterText(find.byType(TextField), 'aloe');
      await tester.pumpAndSettle();
      expect(find.text('No matching plants.'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'rose');
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete scan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(history.images, hasLength(1));
      await tester.tap(find.byTooltip('Delete scan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(history.images, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('clear history requires confirmation and respects cancel', (
    tester,
  ) async {
    final history = Get.find<ImageController>();
    await history.repository.save(
      const ImageModel(
        plantName: 'Rose',
        description: '',
        imagePath: '/missing.jpg',
      ),
      1,
    );
    await history.loadImages(1);
    await mount(tester, const HistoryScreen());
    await tester.tap(find.byTooltip('Clear history'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(history.images, hasLength(1));
    await tester.tap(find.byTooltip('Clear history'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(history.images, isEmpty);
  });
  for (final screen in <Widget>[
    const WelcomeScreen(),
    const AuthScreen(),
    const AuthScreen(isRegister: true),
    const HomeScreen(),
    const HistoryScreen(),
    const ResultsScreen(),
  ]) {
    testWidgets('${screen.runtimeType} fits a small screen with large text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await mount(tester, screen, scale: 2);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('registration remains scrollable with the keyboard open', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await mount(tester, const AuthScreen(isRegister: true), keyboard: 260);
    await tester.scrollUntilVisible(
      find.widgetWithText(ElevatedButton, 'Sign Up'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required.'), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });
}

Future<void> setupLoggedOut() async {
  Get.reset();
  await setupControllers(loggedIn: false);
}
