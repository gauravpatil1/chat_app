import 'package:get/get.dart';

import '../../../chat_details/data/models/chat_model.dart';
import '../../data/datasources/active_chats_remote_data_source.dart';

class ActiveChatsController extends GetxController {
  final ActiveChatsRemoteDataSource activeChatsRemoteDataSource =
      Get.put(ActiveChatsRemoteDataSourceImpl());

  final _activeChats = <ChatModel>[].obs;

  List<ChatModel> get activeChats => _activeChats;

  @override
  void onInit() {
    super.onInit();
    _activeChats.bindStream(activeChatsRemoteDataSource.getActiveChats());
  }

  @override
  void onClose() {
    _activeChats.close();
    super.onClose();
  }
}
