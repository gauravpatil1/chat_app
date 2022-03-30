import 'package:get/get.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../domain/usecases/get_users_on_search.dart';

class UsersListController extends GetxController {
  final _users = <AppUser>[].obs;

  List<AppUser> get users => _users;

  GetAllUsers getAllUsers = Get.put(GetAllUsers());
  GetUsersOnSearch getUsersOnSearch = Get.put(GetUsersOnSearch());

  @override
  void onInit() {
    super.onInit();

    getAllUsersCall();
  }

  /// Fetches List of All users from either Firestore or SharedPreferences
  /// And saves this List to observable [_users]
  Future<void> getAllUsersCall() async {
    var failureOrList = await getAllUsers.call(NoParams());
    failureOrList.fold((failure) {
      _users.value = [];
    }, (usersList) {
      _users.value = usersList;
    });
  }

  /// Fetches List of users from Firestore whose User name matches query parameters
  /// If devices is not connected to internet then fetches List of All users from SharedPreferences
  /// And saves this List to observable [_users]
  Future<void> getUsersOnSearchCall(String value) async {
    var failureOrList = await getUsersOnSearch.call(Params(str: value));
    failureOrList.fold((failure) {
      _users.value = [];
    }, (usersList) {
      _users.value = usersList;
    });
  }
}
