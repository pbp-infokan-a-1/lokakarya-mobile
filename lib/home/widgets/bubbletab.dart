// bubbletab.dart
import 'package:flutter/material.dart';

class BubbleTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;
  final bool isAuthenticated;

  const BubbleTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTabChange,
      items: isAuthenticated
          ? const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: 'Forum & Review',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'User Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
            ]
          : const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.login),
                label: 'Login',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
            ],
    );
  }
}
