import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/app_user_model.dart';

const userListLocalConst = 'ALLUSERSINLOCAL';

abstract class UsersListLocalDataSource {
  /// Saves users list in SharedPreferences
  Future<void> saveUsers(List<AppUserModel> users);

  /// Gets users list from SharedPreferences
  Future<List<AppUserModel>> getUsers();
}

class UsersListLocalDataSourceImpl implements UsersListLocalDataSource {
  SharedPreferences sharedPreferences = Get.find();

  @override
  Future<List<AppUserModel>> getUsers() {
    try {
      return Future.value(
        sharedPreferences
            .getStringList(userListLocalConst)!
            .map((str) => AppUserModel.fromJson(jsonDecode(str)))
            .toList(),
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveUsers(List<AppUserModel> users) {
    try {
      sharedPreferences.setStringList(
        userListLocalConst,
        users
            .map(
              (user) => jsonEncode(user.toJson()),
            )
            .toList(),
      );
    } catch (e) {
      log(e.toString());
    }
    return Future.value();
  }
}
