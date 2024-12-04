import 'package:flutter/material.dart';

class BubbleTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const BubbleTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTabChange,
      selectedItemColor:
          Colors.black, // Set the selected icon and label color to black
      unselectedItemColor:
          Colors.black, // Set the unselected icon and label color to black
      showSelectedLabels: true, // Ensure labels are displayed
      showUnselectedLabels: true, // Ensure unselected labels are displayed
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: 'Forum & Review',
        ),
      ],
    );
  }
}
