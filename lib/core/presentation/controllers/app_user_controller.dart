import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/user_list/data/models/app_user_model.dart';
import '../../../features/user_list/domain/entities/app_user.dart';
import 'auth_controller.dart';

class AppUserController extends GetxController {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _appUser = AppUser(
    uid: '',
    name: 'def --',
    email: '',
    photoUrl: '',
    status: '',
    isOnline: true,
    lastSeen: Timestamp.now(),
  ).obs;
  AppUser get appUser => _appUser.value;

  /// Binds AppUser stream to [_appUser]
  @override
  void onReady() {
    super.onReady();
    _appUser.bindStream(getAppUser());
  }

  /// Closes streams
  @override
  void onClose() {
    _appUser.close();
    super.onClose();
  }

  /// Fetches stream of AppUser document by uid
  Stream<AppUserModel> getAppUser() {
    return firestore
        .collection('users')
        .doc(AuthController.instance.user!.uid)
        .snapshots()
        .map(
          (doc) => AppUserModel.fromJson(doc.data()!),
        );
  }
}
