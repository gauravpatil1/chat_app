import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/controllers/auth_controller.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../chat_details/domain/entities/chat.dart';
import '../../../chat_details/presentation/pages/chat_details_page.dart';
import '../../../user_list/domain/entities/app_user.dart';

class ActiveChatTile extends StatelessWidget {
  final Chat chat;
  const ActiveChatTile({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int userIndex =
        chat.participantsId.first == AuthController.instance.user!.uid ? 1 : 0;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () {
            Get.to(
              () => ChatDetailsPage(
                user: AppUser(
                  uid: chat.participantsId[userIndex],
                  name: chat.participantsName[userIndex],
                  photoUrl: chat.participantsAvatarUrl[userIndex],
                  email: '',
                  status: '',
                  isOnline: false,
                  lastSeen: Timestamp.fromDate(DateTime(1994)),
                ),
              ),
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: chat.participantsAvatarUrl[userIndex],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorWidget: (context, url, err) => PersonIcon(
                size: 25,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          title: Text(
            chat.participantsName[userIndex],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'latest message',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
