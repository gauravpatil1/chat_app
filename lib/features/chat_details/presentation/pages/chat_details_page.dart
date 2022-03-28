import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../user_list/domain/entities/app_user.dart';
import '../../data/models/message_model.dart';
import '../controllers/chat_controller.dart';

class ChatDetailsPage extends StatefulWidget {
  final AppUser user;
  const ChatDetailsPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  late ChatController chatController;
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController(widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = orientation == Orientation.portrait;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFF0E185F),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  titleSpacing: 0,
                  elevation: 0,
                  backgroundColor: const Color(0xFF0E185F),
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.photoUrl,
                          width: 50,
                          height: 50,
                          errorWidget: (context, url, err) => PersonIcon(
                            size: 25,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Online',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                    )
                  ],
                ),
                SliverFillRemaining(
                  child: GetX<ChatController>(builder: (controller) {
                    return Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            return ChatMessageTile(
                              message: controller.messages[index],
                              lastUserWhoSentMessage: index == 0
                                  ? ''
                                  : controller.messages[index - 1].senderName,
                            );
                          },
                        )),
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
                              Expanded(
                                child: TextFormField(
                                  controller: messageController,
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
                                    controller.sendMessageCall(
                                      message: MessageModel(
                                        message: value,
                                        imageAsMessage: '',
                                        receivedAt:
                                            Timestamp.fromDate(DateTime(1994)),
                                        sentAt: Timestamp.now(),
                                        seenAt:
                                            Timestamp.fromDate(DateTime(1994)),
                                        senderAvatarUrl: AuthController
                                                .instance.user!.photoURL ??
                                            '',
                                        senderId:
                                            AuthController.instance.user!.uid,
                                        senderName: AuthController
                                                .instance.user!.displayName ??
                                            '',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () {
                                  controller.uploadChatImage(
                                    callback: (str) {
                                      controller.sendMessageCall(
                                        message: MessageModel(
                                          message: '',
                                          imageAsMessage: str,
                                          receivedAt: Timestamp.fromDate(
                                              DateTime(1994)),
                                          sentAt: Timestamp.now(),
                                          seenAt: Timestamp.fromDate(
                                              DateTime(1994)),
                                          senderAvatarUrl: AuthController
                                                  .instance.user!.photoURL ??
                                              '',
                                          senderId:
                                              AuthController.instance.user!.uid,
                                          senderName: AuthController
                                                  .instance.user!.displayName ??
                                              '',
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatMessageTile extends StatelessWidget {
  final MessageModel message;
  final String lastUserWhoSentMessage;
  const ChatMessageTile({
    Key? key,
    required this.message,
    required this.lastUserWhoSentMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool didUserSentThisMessage =
        message.senderId == AuthController.instance.user!.uid;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            (!didUserSentThisMessage &&
                    lastUserWhoSentMessage != message.senderName)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      imageUrl: message.senderAvatarUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, err) => PersonIcon(
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 40,
                    height: 40,
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: didUserSentThisMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: (!didUserSentThisMessage &&
                        lastUserWhoSentMessage != message.senderName),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        message.senderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: message.imageAsMessage.isNotEmpty,
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child:
                          CachedNetworkImage(imageUrl: message.imageAsMessage),
                    ),
                  ),
                  Visibility(
                    visible: message.imageAsMessage.isEmpty,
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        color: didUserSentThisMessage
                            ? const Color(0xFF6EDCD9)
                            : const Color.fromARGB(255, 61, 71, 146),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message.message,
                        style: TextStyle(
                          color: didUserSentThisMessage
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
