import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/tabs_navigator.dart';

class BottomNavTab extends StatefulWidget {
  const BottomNavTab({super.key});

  static const routeName = '/nav-tabs';

  @override
  State<BottomNavTab> createState() => _BottomNavTabState();
}

enum TabItem { mainPage, notification, newCar, favourites, profile }

class _BottomNavTabState extends State<BottomNavTab> {
  TabItem currentTab = TabItem.mainPage;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.mainPage: GlobalKey<NavigatorState>(),
    TabItem.notification: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
    TabItem.newCar: GlobalKey<NavigatorState>(),
    TabItem.favourites: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await navigatorKeys[currentTab]!.currentState!.maybePop();
          if (isFirstRouteInCurrentTab) {
            // if not on the 'main' tab
            if (currentTab != TabItem.mainPage) {
              // select 'main' tab
              _selectTab(TabItem.mainPage);
              // back button handled by app
              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Stack(children: <Widget>[
            _buildOffstageNavigator(TabItem.mainPage),
            _buildOffstageNavigator(TabItem.notification),
            _buildOffstageNavigator(TabItem.profile),
            _buildOffstageNavigator(TabItem.newCar),
            _buildOffstageNavigator(TabItem.favourites),
          ]),
          bottomNavigationBar: BottomNavigation(
            currentTab: currentTab,
            onSelectTab: _selectTab,
          ),
        ));
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
