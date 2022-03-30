import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/controllers/cloud_firestore_controller.dart';
import '../../../../core/presentation/pages/pages.dart';
import '../../../user_list/presentation/pages/user_list_page.dart';
import '../controllers/active_chats_controller.dart';
import '../widgets/active_chat_tile.dart';

class ActiveChatsPage extends StatefulWidget {
  const ActiveChatsPage({Key? key}) : super(key: key);

  @override
  State<ActiveChatsPage> createState() => _ActiveChatsPageState();
}

class _ActiveChatsPageState extends State<ActiveChatsPage>
    with WidgetsBindingObserver {
  final ActiveChatsController activeChatsController =
      Get.put(ActiveChatsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await CloudFireStoreController.instance.changeAppUserDetails(
        AuthController.instance.user!.uid,
        lastSeen: Timestamp.now(),
        isOnline: true,
      );
    } else {
      await CloudFireStoreController.instance.changeAppUserDetails(
        AuthController.instance.user!.uid,
        lastSeen: Timestamp.now(),
        isOnline: false,
      );
    }
  }

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
