import 'package:bar2_banzeen/app_router.dart';
import 'package:bar2_banzeen/components/theme.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';
import 'package:bar2_banzeen/screens/signup_screen.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/messages_screen.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';

import '../screens/bottom_nav_tab.dart';

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;
  TabNavigator({required this.navigatorKey, required this.tabItem});
  // new routes need to be mapped here as well
  // TODO:: Need to check if I will add all the possible routes for each tab
  Map<TabItem, String> tabsToRouts = {
    TabItem.mainPage: MainPage.routeName,
    TabItem.favourites: LoginScreen.routeName,
    TabItem.notification: SignupScreen.routeName,
    TabItem.profile: MessagingScreen.routeName,
    TabItem.newCar: SellCarScreen.routeName,
  };
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: tabsToRouts[tabItem],
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
