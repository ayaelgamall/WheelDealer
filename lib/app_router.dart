import 'package:bar2_banzeen/screeens/login.dart';
import 'package:bar2_banzeen/screeens/messaging.dart';
import 'package:bar2_banzeen/screeens/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      LoginPage.routeName: (context) => const LoginPage(),
      MessagingScreen.routeName: (context) => const MessagingScreen(),
      SettingsScreen.routeName: (context) => const SettingsScreen(),
    };
    WidgetBuilder builder =
        routes[settings.name] ?? (context) => const LoginPage();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
