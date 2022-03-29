import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../../chat_details/presentation/pages/chat_details_page.dart';
import '../../domain/entities/app_user.dart';

class UserListTile extends StatelessWidget {
  final AppUser user;
  const UserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () {
            Get.to(() => ChatDetailsPage(user: user));
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: user.photoUrl,
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
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            user.status,
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
