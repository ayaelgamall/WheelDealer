import 'package:flutter/material.dart';

class MainHeading extends StatelessWidget {
  String text;
  MainHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 60, 64, 72),
      ),
      textAlign: TextAlign.start,
    );
  }
}
