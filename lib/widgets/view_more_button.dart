import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewMoreText extends StatelessWidget {
  const ViewMoreText({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_forward), iconSize: 25, onPressed: () {});
  }
}
