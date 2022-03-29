import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/users_list_controller.dart';
import '../widgets/users_list_tile.dart';

class UserListPage extends StatelessWidget {
  UserListPage({Key? key}) : super(key: key);

  final UsersListController usersListController =
      Get.put(UsersListController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E185F),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade600,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search user',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        usersListController.getUsersOnSearchCall(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GetX<UsersListController>(
                builder: (controller) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        return UserListTile(user: controller.users[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
