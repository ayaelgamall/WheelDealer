import 'package:bar2_banzeen/main.dart';
import 'package:bar2_banzeen/screens/complete_profile_screen.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/signup_screen.dart';
import 'package:bar2_banzeen/screens/test_overlay.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/screens/test_car_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/test_slider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  static const routeName = '/';

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _login = true;

  void switchLoginSignup() {
    setState(() {
      _login = !_login;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      // return const MyTest();
      // return MyWidget();
      return const TestCarScreen();
      // return const OverlayExample();
      // return _login ? LoginScreen(switchLoginSignup)
      // : SignupScreen(switchLoginSignup);
    } else {
      return StreamBuilder(
        stream: UsersService().isUserProfileComplete(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.exists) {
              return const SellCarScreen();
            } else {
              return const CompleteProfileScreen();
            }
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      );
      // return const CompleteProfileScreen();
    }
  }
}
