import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_firestore_controller.dart';
import '../../../user_list/domain/entities/app_user.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  /// Sends the message to Firestore as a new document to messages collection
  /// this messages collection is the subcollection of chat document whose id is chatId
  Future<ChatModel> sendMessage(
      String chatId, MessageModel message, int oldUnseenCount);

  /// Fetches stream of chat document from Firestore using chatId
  /// If there is no chat document present then this method creates new chat document with chatId
  Future<Stream<ChatModel>> getChat(String chatId, AppUser receiver);

  /// Fetches stream of messages subcollection of chat document whose id is chatId
  Stream<List<MessageModel>> getMessages(String chatId);

  /// Updates chat document and sets unseen count to zero
  /// Updates unseen message documents in messages subcollection of this chat
  void markSeenAndUpdateUnseenCount(String chatId, int oldCount);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<ChatModel> sendMessage(
      String chatId, MessageModel message, int oldUnseenCount) async {
    await CloudFireStoreController.firestore
        .collection('chats/$chatId/messages')
        .add(message.toJson());

    if (message.imageAsMessage.isNotEmpty) {
      await CloudFireStoreController.firestore
          .collection('chats')
          .doc(chatId)
          .update({
        'latestMessage': message.imageAsMessage,
        'latestMessageTime': message.sentAt,
        'isLatestMessageImage': true,
        'latestMessageSenderId': message.senderId,
        'unseenCount': oldUnseenCount + 1,
      });
    } else {
      await CloudFireStoreController.firestore
          .collection('chats')
          .doc(chatId)
          .update({
        'latestMessage': message.message,
        'latestMessageTime': message.sentAt,
        'isLatestMessageImage': false,
        'latestMessageSenderId': message.senderId,
        'unseenCount': oldUnseenCount + 1,
      });
    }

    return CloudFireStoreController.firestore
        .collection('chats')
        .where('chatId', isEqualTo: chatId)
        .get()
        .then((querySnapshot) {
      return ChatModel.fromJson(querySnapshot.docs.first.data());
    });
  }

  @override
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
                latestMessage: '',
                latestMessageTime: Timestamp.now(),
                isLatestMessageImage: false,
                latestMessageSenderId: AuthController.instance.user!.uid,
                unseenCount: 0,
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

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    return CloudFireStoreController.firestore
        .collection('chats/$chatId/messages')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((query) {
      return query.docs.map((doc) {
        return MessageModel.fromJson(doc.data());
      }).toList();
    });
  }

  @override
  Future<void> markSeenAndUpdateUnseenCount(String chatId, int oldCount) async {
    await CloudFireStoreController.firestore
        .collection('chats')
        .doc(chatId)
        .update({'unseenCount': 0});

    await CloudFireStoreController.firestore
        .collection('chats/$chatId/messages')
        .orderBy('sentAt', descending: true)
        .limit(oldCount)
        .get()
        .then((querySnapshot) {
      var docIds = querySnapshot.docs.map((doc) => doc.id).toList();
      for (var id in docIds) {
        CloudFireStoreController.firestore
            .collection('chats/$chatId/messages')
            .doc(id)
            .update({'seenAt': Timestamp.now()});
      }
    });
  }
}
