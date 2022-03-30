import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_firestore_controller.dart';
import '../models/app_user_model.dart';

abstract class UsersListRemoteDataSource {
  /// Fetches a List of Users FireStore who match the query conditions
  /// The query parameter is User name
  Future<List<AppUserModel>> getUsersOnSearch(String str);

  /// Gets All Users from Firestore
  Future<List<AppUserModel>> getAllUsers();
}

class UsersListRemoteDataSourceImpl implements UsersListRemoteDataSource {
  @override
  Future<List<AppUserModel>> getAllUsers() {
    return CloudFireStoreController.firestore
        .collection('users')
        .where('uid', isNotEqualTo: AuthController.instance.user!.uid)
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs
          .map((item) => AppUserModel.fromJson(item.data()))
          .toList();
    });
  }

  @override
  Future<List<AppUserModel>> getUsersOnSearch(String str) {
    return CloudFireStoreController.firestore
        .collection('users')
        .where('name', isEqualTo: str)
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs
          .map((item) => AppUserModel.fromJson(item.data()))
          .toList();
    });
  }
}
