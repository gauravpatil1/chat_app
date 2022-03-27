import 'package:flutter/material.dart';

class PersonIcon extends StatelessWidget {
  final double size;
  final Color color;
  const PersonIcon({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(10),
      child: Icon(
        Icons.person_rounded,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
