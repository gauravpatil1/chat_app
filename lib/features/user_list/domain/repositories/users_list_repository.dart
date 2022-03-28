import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class UsersListRepository {
  Future<Either<Failure, List<AppUser>>> getUsersOnSearch(String str);
  Future<Either<Failure, List<AppUser>>> getAllUsers();
}
