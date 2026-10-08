import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../app/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/image_controller.dart';
import '../controllers/plant_controller.dart';
import '../widgets/history_actions.dart';
import '../widgets/history_state.dart';
import '../widgets/page_body.dart';
import '../widgets/plant_details_dialog.dart';
import '../widgets/plant_image.dart';
import '../widgets/scan_action.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final history = Get.find<ImageController>();
    final plant = Get.find<PlantController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your discoveries')),
      body: PageBody(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (history.isLoading.value ||
                    history.error.value.isNotEmpty ||
                    history.images.isEmpty) {
                  return HistoryState(
                    loading: history.isLoading.value,
                    error: history.error.value,
                    onRetry: () => history.loadImages(
                      Get.find<AuthController>().userId.value,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: history.images.length,
                  itemBuilder: (context, index) {
                    final image = history.images[index];
                    return Card(
                      color: AppColors.orange,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: AppColors.green,
                          width: 3,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => showPlantDetails(context, image),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      image.plantName,
                                      style: const TextStyle(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: PlantImage(
                                      path: image.imagePath,
                                      width: 96,
                                      height: 96,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: HistoryActions(image: image),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: plant.isBusy.value
                      ? null
                      : () => scanPhoto(context, ImageSource.gallery),
                  icon: plant.isBusy.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_outlined),
                  label: Text(
                    plant.isBusy.value ? 'Identifying…' : 'Upload a photo',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
