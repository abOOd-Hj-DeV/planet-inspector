import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/image_controller.dart';
import '../models/image_model.dart';

Future<bool> confirmHistoryAction(
  BuildContext context,
  String title,
  String message,
) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
    false;

Future<void> changeHistory(
  BuildContext context,
  Future<void> Function(int userId) action,
) async {
  try {
    final userId = Get.find<AuthController>().userId.value;
    if (userId > 0) await action(userId);
  } catch (_) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update history. Please try again.'),
        ),
      );
  }
}

class HistoryActions extends StatelessWidget {
  const HistoryActions({super.key, required this.image});
  final ImageModel image;
  @override
  Widget build(BuildContext context) {
    final history = Get.find<ImageController>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: image.isFavorite ? 'Remove favorite' : 'Add favorite',
          icon: Icon(image.isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: () =>
              changeHistory(context, (id) => history.toggleFavorite(image, id)),
        ),
        IconButton(
          tooltip: 'Delete scan',
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            if (await confirmHistoryAction(
                  context,
                  'Delete scan?',
                  'Remove this result from your history?',
                ) &&
                context.mounted) {
              await changeHistory(
                context,
                (id) => history.deleteImage(image, id),
              );
            }
          },
        ),
      ],
    );
  }
}
