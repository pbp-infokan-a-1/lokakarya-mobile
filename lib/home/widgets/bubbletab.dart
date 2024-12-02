// bubbletab.dart
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
          icon: Icon(Icons.forum),
          label: 'Forum & Review',
        ),
      ],
    );
  }
}
