import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/pages.dart';

class AuthBottomButtonWidget extends StatelessWidget {
  final bool isLoginPage;
  final Function function;
  const AuthBottomButtonWidget({
    Key? key,
    required this.isLoginPage,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 50,
              width: double.maxFinite,
            ),
            Container(
              height: 50,
              width: double.maxFinite,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: () => function(),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isLoginPage ? Colors.amber.shade400 : Colors.red.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 25, bottom: 25),
              child: const Icon(
                Icons.arrow_forward,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLoginPage,
          child: Positioned(
            left: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                Get.to(() => ResetPasswordPage());
              },
              child: Container(
                margin: const EdgeInsets.only(left: 25, bottom: 70),
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
