import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../chat_details/data/models/chat_model.dart';

const activeChatsLocalConst = 'ACTIVECHATSINLOCAL';

abstract class ActiveChatsLocalDataSource {
  /// Saves List of Active chats in SharedPreferences
  Future<void> saveActiveChats(List<ChatModel> activeChats);

  /// Fetches List of Active chats from SharedPreferences
  Future<List<ChatModel>> getActiveChats();
}

class ActiveChatsLocalDataSourceImpl implements ActiveChatsLocalDataSource {
  SharedPreferences sharedPreferences = Get.find();

  @override
  Future<List<ChatModel>> getActiveChats() {
    try {
      return Future.value(
        sharedPreferences
            .getStringList(activeChatsLocalConst)!
            .map((str) => ChatModel.fromJson(jsonDecode(str)))
            .toList(),
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveActiveChats(List<ChatModel> activeChats) {
    try {
      sharedPreferences.setStringList(
        activeChatsLocalConst,
        activeChats
            .map(
              (chat) => jsonEncode(chat.toJson()),
            )
            .toList(),
      );
    } catch (e) {
      log(e.toString());
    }
    return Future.value();
  }
}
