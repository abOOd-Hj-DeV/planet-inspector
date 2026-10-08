import 'package:get/get.dart';
import '../data/repositories.dart';
import '../models/image_model.dart';

enum HistorySort { newest, oldest, name }

class ImageController extends GetxController {
  ImageController(this.repository);
  final ImageRepository repository;
  final images = <ImageModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final query = ''.obs;
  final favoritesOnly = false.obs;
  final sort = HistorySort.newest.obs;
  int _loadVersion = 0;

  List<ImageModel> get filteredImages {
    final search = query.value.trim().toLowerCase();
    final result = images
        .where(
          (image) =>
              image.plantName.toLowerCase().contains(search) &&
              (!favoritesOnly.value || image.isFavorite),
        )
        .toList();
    switch (sort.value) {
      case HistorySort.newest:
        result.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      case HistorySort.oldest:
        result.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      case HistorySort.name:
        result.sort(
          (a, b) =>
              a.plantName.toLowerCase().compareTo(b.plantName.toLowerCase()),
        );
    }
    return result;
  }

  Future<void> loadImages(int userId) async {
    final version = ++_loadVersion;
    isLoading.value = true;
    error.value = '';
    try {
      final result = await repository.load(userId);
      if (version == _loadVersion) images.assignAll(result);
    } catch (_) {
      if (version == _loadVersion)
        error.value = 'Could not load history. Please retry.';
    } finally {
      if (version == _loadVersion) isLoading.value = false;
    }
  }

  void clearImages() {
    _loadVersion++;
    images.clear();
    query.value = '';
    favoritesOnly.value = false;
    sort.value = HistorySort.newest;
    error.value = '';
    isLoading.value = false;
  }

  Future<void> clearHistory(int userId) async {
    await repository.clear(userId);
    await loadImages(userId);
  }

  Future<void> deleteImage(ImageModel image, int userId) async {
    if (image.id == null) return;
    await repository.delete(image.id!, userId);
    await loadImages(userId);
  }

  Future<void> toggleFavorite(ImageModel image, int userId) async {
    if (image.id == null) return;
    await repository.setFavorite(image.id!, userId, !image.isFavorite);
    await loadImages(userId);
  }
}
