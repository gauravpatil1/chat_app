import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_firestore_controller.dart';
import '../../../chat_details/data/models/chat_model.dart';
import '../../data/datasources/active_chats_remote_data_source.dart';

class ActiveChatsController extends GetxController {
  final ActiveChatsRemoteDataSource activeChatsRemoteDataSource =
      Get.put(ActiveChatsRemoteDataSourceImpl());

  final _activeChats = <ChatModel>[].obs;

  List<ChatModel> get activeChats => _activeChats;

  /// Binds stream of List of Active chats to [_activeChats]
  @override
  void onInit() {
    super.onInit();
    _activeChats.bindStream(activeChatsRemoteDataSource.getActiveChats());
    ever(_activeChats, markMessagesAsReceived);
  }

  /// This function marks message as received
  /// Updates all unseen messages documents inside messages subcollection of chat document
  /// updates receivedAt Timestamp of message documents to current Timestamp
  Future<void> markMessagesAsReceived(List<ChatModel> chats) async {
    for (var chat in chats) {
      if (chat.unseenCount > 0 &&
          chat.latestMessageSenderId != AuthController.instance.user!.uid) {
        await CloudFireStoreController.firestore
            .collection('chats/${chat.chatId}/messages')
            .orderBy('sentAt', descending: true)
            .limit(chat.unseenCount)
            .get()
            .then((querySnapshot) {
          var docIds = querySnapshot.docs.map((doc) => doc.id).toList();
          for (var id in docIds) {
            CloudFireStoreController.firestore
                .collection('chats/${chat.chatId}/messages')
                .doc(id)
                .update({'receivedAt': Timestamp.now()});
          }
        });
      }
    }
  }

  /// Closes streams
  @override
  void onClose() {
    _activeChats.close();
    super.onClose();
  }
}
