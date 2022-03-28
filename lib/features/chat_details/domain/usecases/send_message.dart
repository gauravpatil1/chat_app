import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<Chat, Params> {
  final ChatRepository repository = Get.put(ChatRepositoryImpl());

  @override
  Future<Either<Failure, Chat>> call(
    Params params,
  ) async {
    return await repository.sendMessage(params.message, params.chatId);
  }
}

class Params extends Equatable {
  final MessageModel message;
  final String chatId;

  const Params({
    required this.message,
    required this.chatId,
  });

  @override
  List<Object> get props => [message];
}
