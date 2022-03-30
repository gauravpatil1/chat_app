import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class UsersListRepository {
  /// Call to get List of Users whose User name matches query parameter
  Future<Either<Failure, List<AppUser>>> getUsersOnSearch(String str);

  /// Call to get All Users
  Future<Either<Failure, List<AppUser>>> getAllUsers();
}
