import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../features/user_list/data/models/app_user_model.dart';

class CloudFireStoreController extends GetxController {
  static CloudFireStoreController instance = Get.find();

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addUserToApp(User user) {
    try {
      firestore.collection('users').doc(user.uid).set(AppUserModel(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL ?? '',
            status: '',
          ).toJson());
    } catch (e) {
      log(e.toString());
    }
  }
}
