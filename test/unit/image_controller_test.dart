import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_finder/controllers/image_controller.dart';
import 'package:plant_finder/models/image_model.dart';
import '../support/fakes.dart';

class DelayedImages extends FakeImages {
  final response = Completer<List<ImageModel>>();
  @override
  Future<List<ImageModel>> load(int userId) => response.future;
}

class DelayedFavorite extends FakeImages {
  final changed = Completer<void>();
  @override
  Future<void> setFavorite(int id, int userId, bool favorite) async {
    await changed.future;
    await super.setFavorite(id, userId, favorite);
  }
}

void main() {
  late FakeImages repository;
  late ImageController history;
  setUp(() async {
    repository = FakeImages();
    history = ImageController(repository);
    await repository.save(
      const ImageModel(plantName: 'Rose', description: '', imagePath: 'a'),
      1,
    );
    await repository.save(
      const ImageModel(
        plantName: 'Aloe',
        description: '',
        imagePath: 'b',
        isFavorite: true,
      ),
      1,
    );
    await repository.save(
      const ImageModel(
        plantName: 'Other user',
        description: '',
        imagePath: 'c',
      ),
      2,
    );
    await history.loadImages(1);
  });
  test(
    'search is case-insensitive, trimmed and stays active after reload',
    () async {
      history.query.value = ' RO ';
      expect(history.filteredImages.single.plantName, 'Rose');
      await history.loadImages(1);
      expect(history.filteredImages.single.plantName, 'Rose');
      history.query.value = 'missing';
      expect(history.filteredImages, isEmpty);
    },
  );
  test('sort and favorites compose without mutating the source list', () {
    expect(history.filteredImages.first.plantName, 'Aloe');
    history.sort.value = HistorySort.oldest;
    expect(history.filteredImages.first.plantName, 'Rose');
    history.sort.value = HistorySort.name;
    expect(history.filteredImages.first.plantName, 'Aloe');
    history.favoritesOnly.value = true;
    expect(history.filteredImages.single.plantName, 'Aloe');
    expect(history.images, hasLength(2));
  });
  test(
    'favorite, delete and clear are scoped to the current account',
    () async {
      await history.toggleFavorite(history.images.first, 1);
      expect(history.images.first.isFavorite, isTrue);
      await history.deleteImage(history.images.first, 1);
      expect(history.images, hasLength(1));
      await history.clearHistory(1);
      expect(history.images, isEmpty);
      expect(await repository.load(2), hasLength(1));
    },
  );
  test(
    'loading failures leave loading state and expose retry feedback',
    () async {
      repository.failLoad = true;
      await history.loadImages(1);
      expect(history.isLoading.value, isFalse);
      expect(history.error.value, isNotEmpty);
      repository.failLoad = false;
      await history.loadImages(1);
      expect(history.error.value, isEmpty);
    },
  );
  test('a pending load cannot repopulate history after logout', () async {
    final delayed = DelayedImages();
    final controller = ImageController(delayed);
    final load = controller.loadImages(1);
    controller.clearImages();
    delayed.response.complete([
      const ImageModel(plantName: 'Private', description: '', imagePath: ''),
    ]);
    await load;
    expect(controller.images, isEmpty);
    expect(controller.isLoading.value, isFalse);
  });
  test(
    'a pending favorite cannot reload the previous account after a switch',
    () async {
      final delayed = DelayedFavorite();
      await delayed.save(
        const ImageModel(plantName: 'Private', description: '', imagePath: ''),
        1,
      );
      await delayed.save(
        const ImageModel(plantName: 'Current', description: '', imagePath: ''),
        2,
      );
      final controller = ImageController(delayed);
      await controller.loadImages(1);
      final change = controller.toggleFavorite(controller.images.single, 1);
      controller.clearImages();
      await controller.loadImages(2);
      delayed.changed.complete();
      await change;
      expect(controller.images.single.plantName, 'Current');
    },
  );
}
