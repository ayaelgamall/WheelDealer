import 'package:flutter/material.dart';

class MainHeading extends StatelessWidget {
  String text;

  Color? color;
  MainHeading({super.key, required this.text,this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
          color: color,
      ),
      textAlign: TextAlign.start,
    );
  }
}
