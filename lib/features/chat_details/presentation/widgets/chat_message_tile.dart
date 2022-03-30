import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../data/models/message_model.dart';

class ChatMessageTile extends StatelessWidget {
  final MessageModel message;
  final String lastUserWhoSentMessage;
  final DateTime dateOfLastMessage;
  const ChatMessageTile({
    Key? key,
    required this.message,
    required this.lastUserWhoSentMessage,
    required this.dateOfLastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool didUserSentThisMessage =
        message.senderId == AuthController.instance.user!.uid;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Visibility(
              visible:
                  (message.sentAt.toDate().year == dateOfLastMessage.year &&
                          message.sentAt.toDate().month ==
                              dateOfLastMessage.month &&
                          message.sentAt.toDate().day == dateOfLastMessage.day)
                      ? false
                      : true,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 173, 99, 99),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${message.sentAt.toDate().day}-${message.sentAt.toDate().month}-${message.sentAt.toDate().year}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
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
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: didUserSentThisMessage
                                ? const Color(0xFF6EDCD9)
                                : const Color.fromARGB(255, 61, 71, 146),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: didUserSentThisMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                  imageUrl: message.imageAsMessage),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      extractSentAtString(message.sentAt),
                                      style: TextStyle(
                                        color: didUserSentThisMessage
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Visibility(
                                      visible: didUserSentThisMessage,
                                      child: buildSeenTicks(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: message.imageAsMessage.isEmpty,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: didUserSentThisMessage
                                ? const Color(0xFF6EDCD9)
                                : const Color.fromARGB(255, 61, 71, 146),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: didUserSentThisMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: didUserSentThisMessage
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    extractSentAtString(message.sentAt),
                                    style: TextStyle(
                                      color: didUserSentThisMessage
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Visibility(
                                    visible: didUserSentThisMessage,
                                    child: buildSeenTicks(),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String extractSentAtString(Timestamp sentAt) {
    DateTime dateTime = sentAt.toDate();
    String amPm = (dateTime.hour / 12 >= 1) ? 'pm' : 'am';
    return (dateTime.hour == 0)
        ? '12:${dateTime.minute} am'
        : (dateTime.hour == 12)
            ? '12:${dateTime.minute} pm'
            : '${dateTime.hour % 12}:${dateTime.minute} ' + amPm;
  }

  buildSeenTicks() {
    if (message.seenAt != Timestamp.fromDate(DateTime(1994))) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        child: Image.asset(
          'assets/double_tick_icon.png',
          width: 12,
          height: 12,
          color: Colors.green.shade900,
        ),
      );
    } else if (message.receivedAt != Timestamp.fromDate(DateTime(1994))) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        child: Image.asset(
          'assets/double_tick_icon.png',
          width: 12,
          height: 12,
          color: Colors.black,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        child: const Icon(
          Icons.check_rounded,
          size: 12,
          color: Colors.black,
        ),
      );
    }
  }
}
