// import 'dart:js';

import 'package:bar2_banzeen/screens/car_screen.dart';
import 'package:bar2_banzeen/screens/edit_profile_screen.dart';
import 'package:bar2_banzeen/screens/complete_profile_screen.dart';
import 'package:bar2_banzeen/screens/favourite_cars_screen.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/signup_screen.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/messages_screen.dart';
import 'package:bar2_banzeen/screens/user_profile_screen.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      Wrapper.routeName: (context) => const Wrapper(),
      // LoginScreen.routeName: (context) => const LoginScreen(),
      // SignupScreen.routeName: (context) => const SignupScreen(),
      MainPage.routeName: (context) => const MainPage(),
      EditProfile.routeName: (context) => const EditProfile(),
      UserProfile.routeName: (context) => const UserProfile(),
      MessagingScreen.routeName: (context) => const MessagingScreen(),
      SellCarScreen.routeName: (context) => const SellCarScreen(),
      ChatScreen.routeName: (context) => const ChatScreen(),
      CompleteProfileScreen.routeName: (context) =>
          const CompleteProfileScreen(),
      // CarPage.routeName: ((context) => const CarPage())
    };
    WidgetBuilder builder =
        routes[settings.name] ?? (context) => const Wrapper();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
