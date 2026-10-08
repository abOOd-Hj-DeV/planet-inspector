import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../app/app_theme.dart';
import '../app/routes.dart';
import '../controllers/auth_controller.dart';
import '../controllers/image_controller.dart';
import '../controllers/plant_controller.dart';
import '../widgets/page_body.dart';
import '../widgets/scan_action.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final history = Get.find<ImageController>();
    final plant = Get.find<PlantController>();
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('img/back.png', fit: BoxFit.cover),
          PageBody(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: 'Log out',
                    icon: const Icon(Icons.logout, color: AppColors.green),
                    onPressed: () async {
                      await auth.logout();
                      Get.offAllNamed(AppRoutes.welcome);
                    },
                  ),
                ),
                const SizedBox(height: 80),
                const Text(
                  'PLANT FINDER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Column(
                    children: [
                      _button(
                        'Album',
                        Icons.photo_library_outlined,
                        plant.isBusy.value
                            ? null
                            : () => scanPhoto(context, ImageSource.gallery),
                      ),
                      _button(
                        'Camera',
                        Icons.camera_alt_outlined,
                        plant.isBusy.value
                            ? null
                            : () => scanPhoto(context, ImageSource.camera),
                      ),
                      _button(
                        'Go to history',
                        Icons.history,
                        plant.isBusy.value
                            ? null
                            : () => Get.toNamed(AppRoutes.history),
                      ),
                      if (plant.isBusy.value)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text('Identifying your plant…'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Card(
                    color: AppColors.background,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Welcome, ${auth.fullName.value}',
                            style: const TextStyle(color: AppColors.green),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${history.images.length} scans  •  ${history.images.where((image) => image.isFavorite).length} favorites',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String label, IconData icon, VoidCallback? onPressed) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          width: 220,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.leaf,
              minimumSize: const Size(220, 60),
              side: const BorderSide(color: AppColors.leaf, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          ),
        ),
      );
}
