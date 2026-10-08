import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:plant_finder/app/app_theme.dart';
import 'package:plant_finder/controllers/image_controller.dart';
import 'package:plant_finder/models/image_model.dart';
import 'package:plant_finder/screens/auth_screen.dart';
import 'package:plant_finder/screens/history_screen.dart';
import 'package:plant_finder/screens/home_screen.dart';
import 'package:plant_finder/screens/results_screen.dart';
import 'package:plant_finder/screens/splash_screen.dart';
import 'package:plant_finder/screens/welcome_screen.dart';
import 'package:plant_finder/widgets/plant_details_dialog.dart';
import '../support/fakes.dart';

const _capture = Key('golden-screen');

Future<void> render(WidgetTester tester, Widget screen, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    RepaintBoundary(
      key: _capture,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: screen,
      ),
    ),
  );
  await tester.runAsync(() async {
    final context = tester.element(find.byType(Scaffold).first);
    for (final asset in ['img/flower.png', 'img/back.png', 'img/splash.jpg']) {
      await precacheImage(AssetImage(asset), context);
    }
    await precacheImage(FileImage(File('img/flower.png').absolute), context);
  });
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    await setupControllers();
  });
  tearDown(Get.reset);
  final screens = <String, Widget>{
    'splash': const SplashScreen(),
    'welcome': const WelcomeScreen(),
    'login': const AuthScreen(),
    'register': const AuthScreen(isRegister: true),
    'home': const HomeScreen(),
    'history_empty': const HistoryScreen(),
    'results_empty': const ResultsScreen(),
  };
  final sizes = <String, Size>{
    'small': const Size(320, 568),
    'mobile': const Size(390, 844),
    'landscape': const Size(844, 390),
    'tablet': const Size(800, 1000),
  };
  for (final screen in screens.entries) {
    for (final size in sizes.entries) {
      testWidgets('${screen.key} ${size.key}', (tester) async {
        await render(tester, screen.value, size.value);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(_capture),
          matchesGoldenFile('baselines/${screen.key}_${size.key}.png'),
        );
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
  for (final screen in <String, Widget>{
    'history_populated': const HistoryScreen(),
    'results_populated': const ResultsScreen(),
  }.entries) {
    for (final size in <String, Size>{
      'mobile': const Size(390, 844),
      'short_landscape': const Size(569, 320),
    }.entries) {
      testWidgets('${screen.key} ${size.key}', (tester) async {
        final history = Get.find<ImageController>();
        await history.repository.save(
          ImageModel(
            plantName: 'Dracaena fragrans',
            description: 'A tropical evergreen plant.',
            imagePath: File('img/flower.png').absolute.path,
            isFavorite: true,
          ),
          1,
        );
        await history.loadImages(1);
        await render(tester, screen.value, size.value);
        if (size.key == 'short_landscape') {
          await tester.scrollUntilVisible(
            find.text('Dracaena fragrans'),
            100,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.pumpAndSettle();
        }
        expect(find.text('Dracaena fragrans').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(_capture),
          matchesGoldenFile('baselines/${screen.key}_${size.key}.png'),
        );
      });
    }
  }
  testWidgets('plant details mobile', (tester) async {
    await render(tester, const HistoryScreen(), const Size(390, 844));
    final context = tester.element(find.byType(Scaffold));
    showPlantDetails(
      context,
      ImageModel(
        plantName: 'Dracaena fragrans',
        description: 'A tropical evergreen plant.',
        imagePath: File('img/flower.png').absolute.path,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(_capture),
      matchesGoldenFile('baselines/details_mobile.png'),
    );
  });
}
