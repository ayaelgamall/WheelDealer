import 'package:bar2_banzeen/screens/editProfile.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/signup_screen.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/messages_screen.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      Wrapper.routeName: (context) => const Wrapper(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      SignupScreen.routeName: (context) => const SignupScreen(),
      MainPage.routeName: (context) => const MainPage(),
      EditProfile.routeName: (context) => const EditProfile(),
      MessagingScreen.routeName: (context) => const MessagingScreen(),
      SellCarScreen.routeName: (context) => const SellCarScreen(),
      ChatScreen.routeName: (context) => const ChatScreen(),
    };
    WidgetBuilder builder =
        routes[settings.name] ?? (context) => const Wrapper();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
