import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../features/chat_details/data/models/chat_model.dart';
import '../../../features/chat_details/data/models/message_model.dart';
import '../../../features/user_list/data/models/app_user_model.dart';

class CloudFireStoreController extends GetxController {
  static CloudFireStoreController instance = Get.find();

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Adds AuthUser as new document to users collection of firestore if not already existing
  Future<void> addUserToApp(User user) async {
    try {
      await firestore.collection('users').doc(user.uid).get().then(
        (doc) {
          if (!doc.exists) {
            firestore.collection('users').doc(user.uid).set(
                  AppUserModel(
                    uid: user.uid,
                    name: user.displayName ?? '',
                    email: user.email ?? '',
                    photoUrl: user.photoURL ?? '',
                    status: '',
                    isOnline: true,
                    lastSeen: Timestamp.now(),
                  ).toJson(),
                );
            createdefaultChatForUser(user);
          }
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  /// Updates a user document from users collection of firestore
  Future<void> changeAppUserDetails(
    String uid, {
    String? name,
    String? email,
    String? photoUrl,
    String? status,
    bool? isOnline,
    Timestamp? lastSeen,
  }) async {
    Map<String, dynamic> updateDoc = {};
    updateDoc.addIf(name != null, 'name', name);
    updateDoc.addIf(email != null, 'email', email);
    updateDoc.addIf(photoUrl != null, 'photoUrl', photoUrl);
    updateDoc.addIf(status != null, 'status', status);
    updateDoc.addIf(isOnline != null, 'isOnline', isOnline);
    updateDoc.addIf(lastSeen != null, 'lastSeen', lastSeen);

    try {
      await firestore.collection('users').doc(uid).update(updateDoc);
    } catch (e) {
      log(e.toString());
    }
  }

  /// Creates dummy chatbot chat when Authuser is added to users collection
  void createdefaultChatForUser(User user) {
    String chatId = user.uid.compareTo('chat_app_bot_id_1994') == -1
        ? user.uid + 'chat_app_bot_id_1994'
        : 'chat_app_bot_id_1994' + user.uid;
    String chatBotAvatar =
        'https://firebasestorage.googleapis.com/v0/b/chat-app-7007e.appspot.com/o/uploads%2FprofileImages%2Fchat_bot.png?alt=media&token=efa43398-5091-4000-8a24-52b3dd83512b';
    String chatBotId = 'chat_app_bot_id_1994';
    String chatBotName = 'Chat Bot';
    String chatBotChatImg =
        'https://firebasestorage.googleapis.com/v0/b/chat-app-7007e.appspot.com/o/uploads%2FchatImages%2Fdemo_chat.jpeg?alt=media&token=027811c2-2a07-4c80-9edb-87c08896f7f4';
    String chatBotChatMsg = 'Welcome to Chat App! 🙏😀 😃 😄';
    firestore.collection('chats').doc(chatId).set(
          ChatModel(
            messages: [].map((item) => item as MessageModel).toList(),
            createdAt: Timestamp.now(),
            participantsAvatarUrl: [
              user.photoURL ?? '',
              chatBotAvatar,
            ],
            participantsId: [
              user.uid,
              chatBotId,
            ],
            participantsName: [
              user.displayName ?? '',
              chatBotName,
            ],
            chatId: chatId,
            latestMessage: chatBotChatMsg,
            latestMessageTime: Timestamp.now(),
            isLatestMessageImage: false,
            latestMessageSenderId: chatBotId,
            unseenCount: 2,
          ).toJson(),
        );
    firestore.collection('chats/$chatId/messages').add(
          MessageModel(
            message: '',
            imageAsMessage: chatBotChatImg,
            receivedAt: Timestamp.fromDate(DateTime(1994)),
            sentAt: Timestamp.now(),
            seenAt: Timestamp.fromDate(DateTime(1994)),
            senderAvatarUrl: chatBotAvatar,
            senderId: chatBotId,
            senderName: chatBotName,
          ).toJson(),
        );
    firestore.collection('chats/$chatId/messages').add(
          MessageModel(
            message: chatBotChatMsg,
            imageAsMessage: '',
            receivedAt: Timestamp.fromDate(DateTime(1994)),
            sentAt: Timestamp.now(),
            seenAt: Timestamp.fromDate(DateTime(1994)),
            senderAvatarUrl: chatBotAvatar,
            senderId: chatBotId,
            senderName: chatBotName,
          ).toJson(),
        );
  }
}
