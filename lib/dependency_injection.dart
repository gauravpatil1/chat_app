import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/presentation/controllers/auth_controller.dart';
import 'core/presentation/controllers/cloud_firestore_controller.dart';
import 'core/presentation/controllers/cloud_storage_controller.dart';
import 'core/presentation/controllers/image_picker_controller.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(AuthController());
  Get.put(CloudStorageController());
  Get.put(CloudFireStoreController());
  Get.put(ImagePickerController());
  Get.put(sharedPreferences);
}
