import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/pages/pages.dart';
import '../../../user_list/presentation/pages/user_list_page.dart';
import '../controllers/active_chats_controller.dart';
import '../widgets/active_chat_tile.dart';

class ActiveChatsPage extends StatelessWidget {
  ActiveChatsPage({Key? key}) : super(key: key);

  final ActiveChatsController activeChatsController =
      Get.put(ActiveChatsController());

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
        child: GetX<ActiveChatsController>(
          builder: (controller) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                itemCount: controller.activeChats.length,
                itemBuilder: (context, index) {
                  return ActiveChatTile(chat: controller.activeChats[index]);
                },
              ),
            );
          },
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
