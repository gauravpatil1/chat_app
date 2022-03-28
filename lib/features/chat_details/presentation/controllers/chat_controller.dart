import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_storage_controller.dart';
import '../../../../core/presentation/controllers/image_picker_controller.dart';
import '../../../user_list/domain/entities/app_user.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/models/message_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecases/send_message.dart';

class ChatController extends GetxController {
  AppUser receiver;
  ChatController(this.receiver);

  SendMessage sendMessage = Get.put(SendMessage());

  final _chat = Chat(
    messages: const [],
    createdAt: Timestamp.now(),
    participantsAvatarUrl: const [],
    participantsId: const [],
    participantsName: const [],
    chatId: '',
  ).obs;

  final _messages = <MessageModel>[].obs;

  List<MessageModel> get messages => _messages;

  Chat get chat => _chat.value;

  @override
  void onInit() {
    super.onInit();
    getOrCreateChat();
  }

  void getOrCreateChat() async {
    String chatId = createChatId(
      receiver.uid,
      AuthController.instance.user!.uid,
    );
    ChatRemoteDataSourceImpl().getChat(chatId, receiver).then((value) {
      _chat.bindStream(value);
      _messages.bindStream(ChatRemoteDataSourceImpl().getMessages(chatId));
    });
  }

  Future<void> sendMessageCall({
    required MessageModel message,
  }) async {
    String chatId = createChatId(
      receiver.uid,
      AuthController.instance.user!.uid,
    );
    var failureOrList = await sendMessage.call(
      Params(
        message: message,
        chatId: chatId,
      ),
    );
    failureOrList.fold((failure) {
      log("failure");
      _chat.value = Chat(
        messages: const [],
        createdAt: Timestamp.now(),
        participantsAvatarUrl: [
          receiver.photoUrl,
          AuthController.instance.user!.photoURL ?? '',
        ],
        participantsId: [
          receiver.uid,
          AuthController.instance.user!.uid,
        ],
        participantsName: [
          receiver.name,
          AuthController.instance.user!.displayName ?? '',
        ],
        chatId: chatId,
      );
    }, (usersList) {
      log("chat success");
      _chat.value = usersList;
    });
  }

  String createChatId(String firstId, String secondId) {
    return firstId.compareTo(secondId) == -1
        ? firstId + secondId
        : secondId + firstId;
  }

  void uploadChatImage({required Function(String) callback}) {
    try {
      ImagePickerController.instance.pickImage(
        callback: (filePath) {
          if (filePath.isNotEmpty) {
            String fileName = 'chatImages/' +
                createChatId(
                  receiver.uid,
                  AuthController.instance.user!.uid,
                ) +
                TimeOfDay.now().toString() +
                '_chatImage.' +
                filePath.split("/").last.split('.').last;
            CloudStorageController.instance
                .uploadFile(path: filePath, fileName: fileName)
                .then((value) async {
              callback(value);
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
