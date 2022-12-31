// ignore_for_file: prefer_const_constructors

import 'package:bar2_banzeen/screens/bids_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TestCarScreen extends StatefulWidget {
  const TestCarScreen({super.key});

  @override
  State<TestCarScreen> createState() => _TestCarScreenState();
}

class _TestCarScreenState extends State<TestCarScreen> {
  bool showBidsScreen = false;

  void showBidsScreenFunc(bool f) {
    setState(() {
      showBidsScreen = f;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            // First child --> all your code goes here
            ElevatedButton(
                onPressed: () {
                  showBidsScreenFunc(true);
                },
                child: Text("Place your bid")),
            // Second child --> just call my widget and pass the function
            if (showBidsScreen) BidsScreen(showBidsScreenFunc)
          ],
        ));
  }
}
