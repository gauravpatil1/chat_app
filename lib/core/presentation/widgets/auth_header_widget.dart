import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/pages.dart';
import 'widgets.dart';

class AuthHeaderWidget extends StatelessWidget {
  final bool isLoginPage;
  final String? imageUrl;
  const AuthHeaderWidget({
    Key? key,
    required this.isLoginPage,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: AuthTitleWidget(
              function: () {
                if (!isLoginPage) {
                  Get.off(() => LoginPage());
                }
              },
              isEnabled: isLoginPage,
              title: 'Login',
            ),
          ),
          Expanded(
            flex: 5,
            child: AuthTitleWidget(
              function: () {
                if (isLoginPage) {
                  Get.off(() => SignUpPage());
                }
              },
              isEnabled: !isLoginPage,
              title: 'Sign Up',
            ),
          ),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        key: UniqueKey(),
                        placeholder: (context, url) => PersonIcon(
                          color: Colors.red.shade400,
                          size: 25,
                        ),
                        errorWidget: (context, url, error) => PersonIcon(
                          color: Colors.red.shade400,
                          size: 25,
                        ),
                      )
                    : PersonIcon(
                        color: Colors.red.shade400,
                        size: 25,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
