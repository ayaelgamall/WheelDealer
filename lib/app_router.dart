

import 'package:bar2_banzeen/screeens/login.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      LoginPage.routeName: (context) => const LoginPage(),


    };
    //  WidgetBuilder builder = routes[settings.name] ?? (context) => const HomeGuest();
    // return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
