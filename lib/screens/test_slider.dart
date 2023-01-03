// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(const MyTest());

class MyTest extends StatelessWidget {
  const MyTest({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    late final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, screenHeight / 150),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
    return Column(
      children: [
        SlideTransition(
          position: _offsetAnimation,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: FlutterLogo(size: 150.0),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              _controller.forward();
            },
            child: Text("Animate")),
        ElevatedButton(
            onPressed: () {
              _controller.reverse();
            },
            child: Text("Reverse"))
      ],
    );
  }
}
