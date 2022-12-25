import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewMoreText extends StatelessWidget {
  const ViewMoreText({super.key});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "See more",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 60, 64, 72),
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.start,
      ),
      onPressed: () {},
    );
  }
}
