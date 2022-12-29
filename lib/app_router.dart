import 'package:bar2_banzeen/screens/editProfile.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/signup_screen.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/messages_screen.dart';
import 'package:bar2_banzeen/screens/user_profile_screen.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      Wrapper.routeName: (context) => const Wrapper(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      SignupScreen.routeName: (context) => const SignupScreen(),
      MainPage.routeName: (context) => const MainPage(),
      EditProfile.routeName: (context) => const EditProfile(),
      UserProfile.routeName: (context) => const UserProfile(),
      MessagingScreen.routeName: (context) => const MessagingScreen(),
      SellCarScreen.routeName: (context) => const SellCarScreen(),
    };
    WidgetBuilder builder =
        routes[settings.name] ?? (context) => const Wrapper();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
