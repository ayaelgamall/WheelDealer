import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewMoreText extends StatelessWidget {
  const ViewMoreText({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_forward), iconSize: 25, onPressed: () {
          context.go("/mainPage/explore");
    });
  }
}
