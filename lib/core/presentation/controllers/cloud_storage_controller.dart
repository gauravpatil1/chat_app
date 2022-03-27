import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class CloudStorageController extends GetxController {
  static CloudStorageController instance = Get.find();

  static final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadFile(
      {required String path, required String fileName}) async {
    File file = File(path);

    try {
      await storage.ref('uploads/$fileName').putFile(file);
      return await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$fileName')
          .getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
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
