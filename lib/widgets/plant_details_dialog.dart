import 'package:flutter/material.dart';
import '../app/app_theme.dart';
import '../models/image_model.dart';
import 'plant_image.dart';

Future<void> showPlantDetails(BuildContext context, ImageModel image) =>
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          image.plantName,
          style: const TextStyle(color: AppColors.green),
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PlantImage(
                    path: image.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  image.description.isEmpty
                      ? 'No description available.'
                      : image.description,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
