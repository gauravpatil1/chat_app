import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/users_list_repository_impl.dart';
import '../entities/app_user.dart';
import '../repositories/users_list_repository.dart';

class GetAllUsers implements UseCase<List<AppUser>, NoParams> {
  final UsersListRepository repository = Get.put(UsersListRepositoryImpl());

  @override
  Future<Either<Failure, List<AppUser>>> call(NoParams params) async {
    return await repository.getAllUsers();
  }
}
