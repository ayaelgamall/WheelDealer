import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: TextButton(
            onPressed: () {
              context.go("/mainPage");
            },
            child: Text("Open")),
      ),
    ));
  }
}
