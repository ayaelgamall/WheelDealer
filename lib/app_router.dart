import 'package:bar2_banzeen/screens/bottom_nav_tab.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/signup_screen.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/messages_screen.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      Wrapper.routeName: (context) => const Wrapper(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      SignupScreen.routeName: (context) => const SignupScreen(),
      MainPage.routeName: (context) => const MainPage(),
      MessagingScreen.routeName: (context) => const MessagingScreen(),
      SellCarScreen.routeName: (context) => const SellCarScreen(),
      // BottomNavTab.routeName: (context) => const BottomNavTab(),
    };
    print(settings.name);
    WidgetBuilder builder = routes[settings.name] ??
        (context) {
          return const Wrapper();
        };
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
