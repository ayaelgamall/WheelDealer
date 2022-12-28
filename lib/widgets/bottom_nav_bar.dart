import 'package:flutter/material.dart';
import '../screens/bottom_nav_tab.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {super.key, required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined), label: "Notifications"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_outlined,
            ),
            label: "Sell car"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_outlined,
            ),
            label: "Favourites"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            label: "Profile")
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: currentTab.index,
    );
  }
}
