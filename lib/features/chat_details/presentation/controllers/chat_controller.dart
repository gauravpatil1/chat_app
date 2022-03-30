import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_firestore_controller.dart';
import '../../../../core/presentation/controllers/cloud_storage_controller.dart';
import '../../../../core/presentation/controllers/image_picker_controller.dart';
import '../../../user_list/data/models/app_user_model.dart';
import '../../../user_list/domain/entities/app_user.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/models/message_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecases/send_message.dart';

class ChatController extends GetxController {
  AppUser receiver;
  ChatController(this.receiver);

  final SendMessage sendMessage = Get.put(SendMessage());
  final ChatRemoteDataSource chatRemoteDataSource =
      Get.put(ChatRemoteDataSourceImpl());

  final _chat = Chat(
    messages: const [],
    createdAt: Timestamp.now(),
    participantsAvatarUrl: const [],
    participantsId: const [],
    participantsName: const [],
    chatId: '',
    latestMessage: '',
    latestMessageTime: Timestamp.now(),
    isLatestMessageImage: false,
    latestMessageSenderId: '',
    unseenCount: 0,
  ).obs;

  Chat get chat => _chat.value;

  final _messages = <MessageModel>[].obs;

  List<MessageModel> get messages => _messages;

  final _otherPerson = AppUser(
    uid: '',
    name: '',
    email: '',
    photoUrl: '',
    status: '',
    isOnline: false,
    lastSeen: Timestamp.fromDate(DateTime(1994)),
  ).obs;

  AppUser get otherPerson => _otherPerson.value;

  @override
  void onInit() {
    super.onInit();
    getOrCreateChat();
  }

  /// Fetches chat stream from firestore with chatId as id
  /// if there is no chat document present then creates and saves the chat document in firestore with chatId as id
  /// Binds chat stream to [_chat]
  /// Fetches List of messages stream from firestore
  /// Binds messages stream to [_messages]
  /// Fetches AppUser stream from firestore. This is the other person in chat conversation
  /// Binds this other person stream to [_otherPerson]
  void getOrCreateChat() async {
    String chatId = createChatId(
      receiver.uid,
      AuthController.instance.user!.uid,
    );
    chatRemoteDataSource.getChat(chatId, receiver).then((value) {
      _chat.bindStream(value);
      ever(_chat, _checkForUnseenMessages);
      _messages.bindStream(chatRemoteDataSource.getMessages(chatId));
      _otherPerson.bindStream(getOtherUser(receiver.uid));
    });
  }

  /// Checks whether there are any unseen messages sent from other person
  /// and if there is any unseen message then updates the firestore chat document and messages collection accordingly
  /// i.e,
  ///   sets unseenCount in chat document to zero
  ///   sets receivedAt Timestamp of every unseen message in messages subcollection to current Timestamp
  void _checkForUnseenMessages(Chat chat) {
    String chatId = createChatId(
      receiver.uid,
      AuthController.instance.user!.uid,
    );
    if (chat.unseenCount > 0 && chat.latestMessageSenderId == receiver.uid) {
      chatRemoteDataSource.markSeenAndUpdateUnseenCount(
          chatId, chat.unseenCount);
    }
  }

  ///Closes all streams
  @override
  void onClose() {
    _chat.close();
    _messages.close();
    _otherPerson.close();
    super.onClose();
  }

  /// Call to send new message to firestore
  Future<void> sendMessageCall({
    required MessageModel message,
    required int oldUnseenCount,
  }) async {
    String chatId = createChatId(
      receiver.uid,
      AuthController.instance.user!.uid,
    );
    var failureOrList = await sendMessage.call(
      Params(
        message: message,
        chatId: chatId,
        oldUnseenCount: oldUnseenCount,
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
        latestMessage: '',
        latestMessageTime: Timestamp.now(),
        isLatestMessageImage: false,
        latestMessageSenderId: AuthController.instance.user!.displayName ?? '',
        unseenCount: 0,
      );
    }, (usersList) {
      log("chat success");
      _chat.value = usersList;
    });
  }

  /// Creates unique chatId using user Ids of AppUsers in chat and returns as string;
  String createChatId(String firstId, String secondId) {
    return firstId.compareTo(secondId) == -1
        ? firstId + secondId
        : secondId + firstId;
  }

  /// Uploads image as chat message in firebase storage and returns a callback with stored image url
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

  /// Fetches and returns the AppUser stream.
  /// Here AppUser is other person in chat
  Stream<AppUserModel> getOtherUser(String id) {
    return CloudFireStoreController.firestore
        .collection('users')
        .doc(id)
        .snapshots()
        .map(
          (doc) => AppUserModel.fromJson(doc.data()!),
        );
  }
}
