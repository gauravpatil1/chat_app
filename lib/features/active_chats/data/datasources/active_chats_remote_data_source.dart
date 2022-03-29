import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_firestore_controller.dart';
import '../../../chat_details/data/models/chat_model.dart';

abstract class ActiveChatsRemoteDataSource {
  Stream<List<ChatModel>> getActiveChats();
}

class ActiveChatsRemoteDataSourceImpl implements ActiveChatsRemoteDataSource {
  @override
  Stream<List<ChatModel>> getActiveChats() {
    return CloudFireStoreController.firestore
        .collection('chats')
        .where('participantsId',
            arrayContains: AuthController.instance.user!.uid)
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => ChatModel.fromJson(doc.data())).toList();
    });
  }
}
