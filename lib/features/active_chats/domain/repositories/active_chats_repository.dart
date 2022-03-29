import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../chat_details/domain/entities/chat.dart';

abstract class ActiveChatsRepository {
  Future<Either<Failure, List<Chat>>> getActiveChats();
}
