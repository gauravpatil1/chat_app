import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/user_list/presentation/pages/user_list_page.dart';
import '../controllers/auth_controller.dart';
import 'pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E185F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0E185F),
        title: const Text(
          "Chat App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => SettingsPage());
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "data " + AuthController.instance.user!.email!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => UserListPage());
        },
        backgroundColor: Colors.red.shade400,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
