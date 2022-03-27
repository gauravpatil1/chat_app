import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';

class AuthSocialWidget extends StatelessWidget {
  const AuthSocialWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          Visibility(
            visible: false,
            child: InkWell(
              onTap: () {},
              child: Image.asset(
                'assets/facebook_icon.png',
              ),
            ),
          ),
          const SizedBox(width: 20),
          InkWell(
            onTap: () {
              AuthController.instance.signInWithGoogle();
            },
            child: Image.asset(
              'assets/google_icon.png',
              scale: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
