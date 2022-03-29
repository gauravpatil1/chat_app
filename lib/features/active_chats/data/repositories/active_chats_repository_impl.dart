import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../chat_details/domain/entities/chat.dart';
import '../../domain/repositories/active_chats_repository.dart';
import '../datasources/active_chats_local_data_source.dart';
import '../datasources/active_chats_remote_data_source.dart';

class ActiveChatsRepositoryImpl implements ActiveChatsRepository {
  final ActiveChatsLocalDataSource activeChatsLocalDataSource =
      Get.put(ActiveChatsLocalDataSourceImpl());
  final ActiveChatsRemoteDataSource activeChatsRemoteDataSource =
      Get.put(ActiveChatsRemoteDataSourceImpl());
  final NetworkInfo networkInfo = Get.put(NetworkInfoImpl());

  @override
  Future<Either<Failure, List<Chat>>> getActiveChats() async {
    if (await networkInfo.isConnected) {
      try {
        final activeChats = activeChatsRemoteDataSource.getActiveChats();
        List<Chat> rcvdChats = [];
        activeChats.listen((chats) {
          activeChatsLocalDataSource.saveActiveChats(chats);
          rcvdChats = chats;
        });
        return Right(rcvdChats);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final activeChats = await activeChatsLocalDataSource.getActiveChats();
        return Right(activeChats);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
