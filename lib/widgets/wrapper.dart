import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/test_car_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/bids_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const TestCarScreen();
      // return const BidsScreen();
      // return const LoginScreen();
    } else {
      return const SellCarScreen();
    }
  }
}
