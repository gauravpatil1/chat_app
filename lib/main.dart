import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/presentation/controllers/auth_controller.dart';
import 'core/presentation/controllers/cloud_storage_controller.dart';
import 'core/presentation/controllers/image_picker_controller.dart';
import 'core/presentation/pages/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put(AuthController());
    Get.put(sharedPreferences);
    Get.put(ImagePickerController());
    Get.put(CloudStorageController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
