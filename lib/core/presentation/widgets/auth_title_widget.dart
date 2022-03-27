import 'package:flutter/material.dart';

class AuthTitleWidget extends StatelessWidget {
  final String title;
  final Function function;
  final bool isEnabled;
  const AuthTitleWidget({
    Key? key,
    required this.title,
    required this.function,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: TextStyle(
            shadows: [
              Shadow(
                color: isEnabled ? Colors.black : Colors.grey,
                offset: const Offset(0, -5),
              )
            ],
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.transparent,
            decoration: isEnabled ? TextDecoration.underline : null,
            decorationColor: Colors.black,
            decorationThickness: 2,
            decorationStyle: TextDecorationStyle.solid,
          ),
        ),
      ),
    );
  }
}
