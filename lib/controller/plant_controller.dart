// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

//http://127.0.0.1:5000
class PlantController extends GetxController {
  List allowPlant = ["Amaranthus blitum","Dracaena fragrans","Ravenala madagascariensis","sdhow"] ;
  var plantDetails = {}.obs;
  var v = ''.obs;
  var description = ''.obs;

  Future<void> identifyPlant(File imageFile) async {
    final uri = Uri.parse('http://192.168.1.110:5000/identify_plant');
   

    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        plantDetails.value = jsonDecode(responseData);

        if (plantDetails.value.isNotEmpty) {
          v.value = plantDetails.value['name'] ?? 'Unknown';
          description.value = plantDetails.value['description']?['value'] ??
              'No description available';
          print(description);
        } else {
          print('Error: No plant data received.');
          // يمكنك أيضًا إعادة تعيين القيم هنا إذا كنت ترغب في ذلك
          v.value = '';
          description.value = '';
        }
      } else {
        var errorData = await response.stream.bytesToString();
        var errorMessage = jsonDecode(errorData)['message'] ?? 'Unknown error';
        print('Error: $errorMessage');
        // إعادة تعيين القيم هنا أيضًا
        v.value = '';
        description.value = '';
      }
    } catch (e) {
      print('Error: $e');
      // إعادة تعيين القيم في حالة حدوث استثناء
      v.value = 'no connection';
      description.value = 'no connection';
    }
  }
}
