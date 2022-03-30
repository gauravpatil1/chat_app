import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  static ImagePickerController instance = Get.find();

  static final ImagePicker _picker = ImagePicker();

  /// Shows bottomsheet and user can either select from gallery or from Camera
  /// returns a callback with file path
  void pickImage({required Function(String) callback}) {
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _getImage(isFromGallery: true).then((value) {
                  if (value != null) {
                    callback(value.path);
                  } else {
                    callback('');
                  }
                });
                Get.back();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(27),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade900,
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.image,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            InkWell(
              onTap: () {
                _getImage(isFromGallery: false).then((value) {
                  if (value != null) {
                    callback(value.path);
                  } else {
                    callback('');
                  }
                });
                Get.back();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(27),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade900,
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Camera",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
      elevation: 10,
    );
  }

  /// opens Image picker according to conditions provided
  Future<XFile?> _getImage({required bool isFromGallery}) async {
    XFile? image;
    if (isFromGallery) {
      image = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await _picker.pickImage(source: ImageSource.camera);
    }

    return image;
  }
}
