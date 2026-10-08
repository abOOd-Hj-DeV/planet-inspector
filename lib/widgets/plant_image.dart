import 'dart:io';
import 'package:flutter/material.dart';
import '../app/app_theme.dart';

class PlantImage extends StatelessWidget {
  const PlantImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });
  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.file(
    File(path),
    height: height,
    width: width,
    fit: fit,
    errorBuilder: (_, error, stack) => Container(
      height: height,
      width: width,
      color: AppColors.lightGreen,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.green,
          semanticLabel: 'Photo unavailable',
        ),
      ),
    ),
  );
}
