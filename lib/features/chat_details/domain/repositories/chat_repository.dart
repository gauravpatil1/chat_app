import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/message_model.dart';
import '../entities/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, Chat>> sendMessage(
      MessageModel message, String chatId);
}
