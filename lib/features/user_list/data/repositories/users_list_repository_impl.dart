import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_list_repository.dart';
import '../datasources/users_list_local_data_source.dart';
import '../datasources/users_list_remote_data_source.dart';

class UsersListRepositoryImpl implements UsersListRepository {
  final UsersListLocalDataSource usersListLocalDataSource =
      Get.put(UsersListLocalDataSourceImpl());
  final UsersListRemoteDataSource usersListRemoteDataSource =
      Get.put(UsersListRemoteDataSourceImpl());
  final NetworkInfo networkInfo = Get.put(NetworkInfoImpl());

  @override
  Future<Either<Failure, List<AppUser>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final users = await usersListRemoteDataSource.getAllUsers();
        usersListLocalDataSource.saveUsers(users);
        return Right(users);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final users = await usersListLocalDataSource.getUsers();
        return Right(users);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<AppUser>>> getUsersOnSearch(String str) async {
    if (await networkInfo.isConnected) {
      try {
        final users = await usersListRemoteDataSource.getUsersOnSearch(str);
        return Right(users);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final users = await usersListLocalDataSource.getUsers();
        return Right(users);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
