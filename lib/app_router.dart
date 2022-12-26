import 'package:bar2_banzeen/screens/messaging.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      MessagingScreen.routeName: (context) => const MessagingScreen(),
    };
    WidgetBuilder builder =
        routes[settings.name] ?? (context) => const MessagingScreen();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
