import 'package:flutter/material.dart';

class AuthWelcomeMessageWidget extends StatelessWidget {
  const AuthWelcomeMessageWidget({
    Key? key,
    this.prevUsername,
  }) : super(key: key);

  final String? prevUsername;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: RichText(
            text: TextSpan(
              text: prevUsername != null ? 'Welcome Back,' : 'Hello ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w200,
              ),
              children: [
                TextSpan(
                  text: prevUsername != null ? '\n$prevUsername' : 'Beautiful,',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: prevUsername == null,
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: const Text(
              'Enter your informations below or login with a social account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
