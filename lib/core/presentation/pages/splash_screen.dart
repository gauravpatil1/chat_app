import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            color: Colors.amber.shade400,
          ),
        ),
      ),
    );
  }
}
