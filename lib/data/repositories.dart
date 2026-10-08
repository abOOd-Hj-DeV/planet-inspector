import '../models/image_model.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> findByEmail(String email);
  Future<UserModel?> findById(int id);
  Future<int> insert(UserModel user);
}

abstract class ImageRepository {
  Future<List<ImageModel>> load(int userId);
  Future<void> save(ImageModel image, int userId);
  Future<void> clear(int userId);
  Future<void> delete(int id, int userId);
  Future<void> setFavorite(int id, int userId, bool favorite);
}
