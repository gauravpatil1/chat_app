import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource chatLocalDataSource =
      Get.put(ChatLocalDataSourceImpl());
  final ChatRemoteDataSource chatRemoteDataSource =
      Get.put(ChatRemoteDataSourceImpl());
  final NetworkInfo networkInfo = Get.put(NetworkInfoImpl());

  @override
  Future<Either<Failure, Chat>> sendMessage(
    MessageModel message,
    String chatId,
    int oldUnseenCount,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await chatRemoteDataSource.sendMessage(
          chatId,
          message,
          oldUnseenCount,
        );
        chatLocalDataSource.saveChat(chat);
        return Right(chat);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final chat = await chatLocalDataSource.getChat(chatId);
        return Right(chat);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
