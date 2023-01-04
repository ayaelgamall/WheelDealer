// import 'dart:js';

import 'package:bar2_banzeen/screens/edit_profile_screen.dart';
import 'package:bar2_banzeen/screens/complete_profile_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/user_profile_screen.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      Wrapper.routeName: (context) => const Wrapper(),
      MainPage.routeName: (context) => const MainPage(),
      EditProfile.routeName: (context) => const EditProfile(),
      UserProfile.routeName: (context) => const UserProfile(),
      SellCarScreen.routeName: (context) => const SellCarScreen(),
      CompleteProfileScreen.routeName: (context) =>
          const CompleteProfileScreen(),
    };
    WidgetBuilder builder =
        routes[settings.name] ?? (context) => const Wrapper();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
