import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_firestore_controller.dart';
import '../../../user_list/domain/entities/app_user.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> sendMessage(String chatId, MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<ChatModel> sendMessage(String chatId, MessageModel message) {
    CloudFireStoreController.firestore
        .collection('chats/$chatId/messages')
        .add(message.toJson());

    return CloudFireStoreController.firestore
        .collection('chats')
        .where('chatId', isEqualTo: chatId)
        .get()
        .then((querySnapshot) {
      return ChatModel.fromJson(querySnapshot.docs.first.data());
    });
  }

  Future<Stream<ChatModel>> getChat(String chatId, AppUser receiver) {
    return CloudFireStoreController.firestore
        .collection('chats')
        .where('chatId', isEqualTo: chatId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        CloudFireStoreController.firestore.collection('chats').doc(chatId).set(
              ChatModel(
                messages: [].map((item) => item as MessageModel).toList(),
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
              ).toJson(),
            );
        return CloudFireStoreController.firestore
            .collection('chats')
            .where('chatId', isEqualTo: chatId)
            .snapshots()
            .map((query) {
          return ChatModel.fromJson(query.docs.first.data());
        });
      } else {
        return CloudFireStoreController.firestore
            .collection('chats')
            .where('chatId', isEqualTo: chatId)
            .snapshots()
            .map((query) {
          return ChatModel.fromJson(query.docs.first.data());
        });
      }
    });
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return CloudFireStoreController.firestore
        .collection('chats/$chatId/messages')
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((query) {
      return query.docs.map((doc) {
        return MessageModel.fromJson(doc.data());
      }).toList();
    });
  }
}
