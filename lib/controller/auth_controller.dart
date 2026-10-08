import 'package:get/get.dart';
import 'package:plant_finder/controller/image_controller.dart';
import 'package:plant_finder/helpers/database_helper.dart';
import 'package:plant_finder/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
ImageController controller = Get.put(ImageController());

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var userId = RxInt(0); // تحويل userId إلى RxInt

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    
    // استرجاع userId من SharedPreferences وتحديثه
    userId.value = prefs.getInt('userId') ?? 0;

    print('Is logged in: ${isLoggedIn.value}');
    print('User ID: ${userId.value}');

    if (isLoggedIn.value) {
      Get.offNamed('/a');
    } else {
      Get.offNamed('/essential');
    }
  }

  Future<void> register(String fullName, String email, String password) async {
    var existingUser = await DatabaseHelper().getUser(email, password);
    if (existingUser != null) {
      Get.snackbar('Error', 'User already exists with this email');
      return;
    }

    UserModel user =
        UserModel(fullName: fullName, email: email, password: password);
    await DatabaseHelper().insertUser(user);
    Get.snackbar('Success', 'User registered successfully');
  }

  Future<bool> login(String email, String password) async {
    UserModel? user = await DatabaseHelper().getUser(email, password);
    if (user != null) {
      isLoggedIn.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', user.id!); // تأكد من أن user.id هو int
      
      // تحديث userId
      userId.value = user.id!; 
      await controller.loadImages(user.id!);
      Get.offAllNamed('/mainp');

      return true;
    }
    Get.snackbar('Error', 'Invalid email or password');
    return false;
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId'); // إزالة id المستخدم عند تسجيل الخروج
    controller.clearImages();    
    // إعادة تعيين userId
    userId.value = 12369878978987987; 
    Get.deleteAll();

    Get.snackbar('Success', 'Logged out successfully');
    Get.offNamed('/essential');
  }

  // يمكن استخدام هذا الدالة لاستعادة id المستخدم
  int? getCurrentUserId() {
    return userId.value; 
  }
}
