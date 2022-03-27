import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/pages.dart';
import 'cloud_storage_controller.dart';
import 'image_picker_controller.dart';

const usernameConst = 'USERNAME';
const userImageConst = 'USERIMAGE';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  static SharedPreferences sharedPreferences = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  var isSignedInusingGoogle = false.obs;

  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _onUserStateChange);
  }

  _onUserStateChange(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(
        () => const HomePage(),
      );
    }
  }

  /// Creates the user with [email] and [password] and shows [snackbar] if any error occurs
  void signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Sign up failed!",
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
    }
  }

  /// Signs in the user with [email] and [password] and shows [snackbar] if any error occurs
  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Login failed!",
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
    }
  }

  /// Logs out the user
  void logOut() async {
    try {
      saveUsernameToLocale(auth.currentUser!.displayName ?? '');
      saveUserImageToLocale(auth.currentUser!.photoURL ?? '');
      if (isSignedInusingGoogle.value) {
        await googleSignIn.disconnect();
      }
      await auth.signOut();
    } catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Logout failed!",
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
    }
  }

  /// Creates or Signs in the user using Google credentials and shows [snackbar] if any error occurs
  void signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Failed to sign in with google account");
      } else {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential);
        isSignedInusingGoogle = RxBool(true);
      }
    } catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Google Signing in failed!",
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
      isSignedInusingGoogle = RxBool(false);
    }
  }

  /// Sends reset password link to the [email] and shows [snackbar] if any error occurs
  void resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Password reset link sent to your email!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: const Text(
          "Please use this link to reset password",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Password reset failed!",
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
    }
  }

  /// Save username in SharedPreferences to show in welcome note while logging again.
  void saveUsernameToLocale(String name) {
    sharedPreferences.setString(
      usernameConst,
      name,
    );
  }

  /// Get username from SharedPreferences to show in welcome note while logging again.
  String? getUsernameFromLocale() {
    try {
      return sharedPreferences.getString(usernameConst);
    } catch (e) {
      return null;
    }
  }

  /// Save userImage in SharedPreferences to show in welcome note while logging again.
  void saveUserImageToLocale(String name) {
    sharedPreferences.setString(
      userImageConst,
      name,
    );
  }

  /// Get userImage from SharedPreferences to show in welcome note while logging again.
  String? getUserImageFromLocale() {
    try {
      return sharedPreferences.getString(userImageConst);
    } catch (e) {
      return null;
    }
  }

  /// Change user display name
  Future<void> changeUsername(String value) async {
    try {
      await auth.currentUser!.updateDisplayName(value);
    } catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Failed to change user display name!",
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
    }
  }

  /// Change user image by first selecting image using image picker
  void changeUserImage() {
    try {
      ImagePickerController.instance.pickImage(
        callback: (filePath) {
          if (filePath.isNotEmpty) {
            String fileName = 'profileImages/' +
                user!.uid.toString() +
                '_ProfileImage.' +
                filePath.split("/").last.split('.').last;
            CloudStorageController.instance
                .uploadFile(path: filePath, fileName: fileName)
                .then((value) async {
              if (value.isNotEmpty) {
                await auth.currentUser!.updatePhotoURL(value);
              }
            });
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        "title",
        "message",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        titleText: const Text(
          "Failed to change user profile image!",
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
    }
  }
}
