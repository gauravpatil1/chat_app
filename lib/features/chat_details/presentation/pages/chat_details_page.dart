import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../user_list/domain/entities/app_user.dart';
import '../../data/models/message_model.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_message_tile.dart';

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
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.photoUrl,
                          width: 40,
                          height: 40,
                          errorWidget: (context, url, err) => PersonIcon(
                            size: 20,
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
                            GetX<ChatController>(builder: (controller) {
                              return controller.otherPerson.isOnline
                                  ? Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    )
                                  : Text(
                                      'last seen ' +
                                          getLastSeen(
                                              controller.otherPerson.lastSeen),
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 10,
                                      ),
                                    );
                            }),
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
                          reverse: true,
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            return ChatMessageTile(
                              message: controller.messages[index],
                              lastUserWhoSentMessage: index == 0
                                  ? ''
                                  : controller.messages[index - 1].senderName,
                              dateOfLastMessage:
                                  index == controller.messages.length - 1
                                      ? DateTime(1994, 1, 1)
                                      : controller.messages[index + 1].sentAt
                                          .toDate(),
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
                                    hintText: 'Message',
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
                                      oldUnseenCount:
                                          controller.chat.unseenCount,
                                    );
                                    messageController.text = '';
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
                                        oldUnseenCount:
                                            controller.chat.unseenCount,
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

  String getLastSeen(Timestamp lastSeen) {
    DateTime dateTime = lastSeen.toDate();
    String amPm = (dateTime.hour / 12 >= 1) ? 'pm' : 'am';
    var atPart = (dateTime.hour == 0)
        ? ' at 12:${dateTime.minute} am'
        : (dateTime.hour == 12)
            ? '12:${dateTime.minute} pm'
            : ' at ${dateTime.hour % 12}:${dateTime.minute} ' + amPm;
    var now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'today' + atPart;
    } else {
      return '${dateTime.day}-${dateTime.month}-${dateTime.year}' + atPart;
    }
  }
}
