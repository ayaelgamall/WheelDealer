import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectedTab extends StatelessWidget {
  final Widget child;
  const SelectedTab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border_outlined,
              ),
              label: "Favourites"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
              ),
              label: "Sell car"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined), label: "Notifications"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
              ),
              label: "Profile")
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith('/mainPage')) {
      return 0;
    }
    if (location.startsWith('/favourites')) {
      return 1;
    }
    if (location.startsWith('/sellCar')) {
      return 2;
    }
    if (location.startsWith('/notifications')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/mainPage');
        break;
      case 1:
        GoRouter.of(context).go('/favourites');
        break;
      case 2:
        GoRouter.of(context).go('/sellCar');
        break;
      case 3:
        GoRouter.of(context).go('/notifications');
        break;
      case 4:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}
