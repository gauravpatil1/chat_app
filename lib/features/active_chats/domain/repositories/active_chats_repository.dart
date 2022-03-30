import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../chat_details/domain/entities/chat.dart';

abstract class ActiveChatsRepository {
  /// Fetches List of Active chats from firestore
  /// Or
  /// Fetches List of Active chats from SharedPreferences when there is no internet connection
  Future<Either<Failure, List<Chat>>> getActiveChats();
}
