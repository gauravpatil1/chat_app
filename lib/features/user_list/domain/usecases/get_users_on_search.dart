import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/users_list_repository_impl.dart';
import '../entities/app_user.dart';
import '../repositories/users_list_repository.dart';

class GetUsersOnSearch implements UseCase<List<AppUser>, Params> {
  final UsersListRepository repository = Get.put(UsersListRepositoryImpl());

  @override
  Future<Either<Failure, List<AppUser>>> call(Params params) async {
    return await repository.getUsersOnSearch(params.str);
  }
}

class Params extends Equatable {
  final String str;

  const Params({
    required this.str,
  });

  @override
  List<Object> get props => [str];
}
