import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/chat_model.dart';

abstract class ChatLocalDataSource {
  Future<void> saveChat(ChatModel chat);

  Future<ChatModel> getChat(String id);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  SharedPreferences sharedPreferences = Get.find();

  @override
  Future<ChatModel> getChat(String id) {
    try {
      return Future.value(
          ChatModel.fromJson(jsonDecode(sharedPreferences.getString(id)!)));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveChat(ChatModel chat) {
    try {
      sharedPreferences.setString(
        chat.chatId,
        jsonEncode(chat.toJson()),
      );
    } catch (e) {
      log(e.toString());
    }
    return Future.value();
  }
}
