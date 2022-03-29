import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../chat_details/domain/entities/chat.dart';
import '../../data/repositories/active_chats_repository_impl.dart';
import '../repositories/active_chats_repository.dart';

class GetActiveChats implements UseCase<List<Chat>, NoParams> {
  final ActiveChatsRepository repository = Get.put(ActiveChatsRepositoryImpl());

  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) async {
    return await repository.getActiveChats();
  }
}
