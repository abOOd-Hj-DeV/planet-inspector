import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/plant_controller.dart';
import '../services/plant_service.dart';
import 'plant_details_dialog.dart';

Future<void> scanPhoto(BuildContext context, ImageSource source) async {
  try {
    final result = await Get.find<PlantController>().pickAndIdentify(source);
    if (result != null && context.mounted)
      await showPlantDetails(context, result);
  } catch (error) {
    if (!context.mounted) return;
    final message = error is PlantServiceException
        ? error.message
        : 'Could not process this photo. Please check permissions and try again.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
