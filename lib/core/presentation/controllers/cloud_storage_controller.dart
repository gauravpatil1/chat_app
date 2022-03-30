import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageController extends GetxController {
  static CloudStorageController instance = Get.find();

  static final FirebaseStorage storage = FirebaseStorage.instance;

  ///Uploads a file to firebase storage and returns download url for that file
  Future<String> uploadFile(
      {required String path, required String fileName}) async {
    File file = File(path);

    try {
      await storage.ref('uploads/$fileName').putFile(file);
      return await FirebaseStorage.instance
          .ref('uploads/$fileName')
          .getDownloadURL();
    } on FirebaseException catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Failed to upload file!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      return '';
    }
  }
}
