import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/message_model.dart';
import '../entities/chat.dart';

abstract class ChatRepository {
  /// Sends message to Firestore and fetches the chat document
  /// if there is no internet connection it fetches chat from SharedPreferences
  Future<Either<Failure, Chat>> sendMessage(
      MessageModel message, String chatId, int oldUnseenCount);
}
