// ignore_for_file: prefer_const_constructors

import 'package:bar2_banzeen/screeens/settings_screen.dart';
import 'package:flutter/material.dart';
import '../screeens/settings_screen.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (() {
        Navigator.of(context).pushNamed(SettingsScreen.routeName);
      }),
      icon: Icon(Icons.settings_outlined),
      color: Color(0xFFCCCCCC),
    );
  }
}
