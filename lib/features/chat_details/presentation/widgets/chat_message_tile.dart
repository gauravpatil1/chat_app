import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../data/models/message_model.dart';

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
