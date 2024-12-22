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
    final int itemCount = isAuthenticated ? 4 : 3;

    final int validIndex = selectedIndex < itemCount ? selectedIndex : 0;

    return BottomNavigationBar(
      currentIndex: validIndex,
      onTap: onTabChange,
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: isAuthenticated
          ? const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: 'Forum & Review',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'User Profile',
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
            ],
    );
  }
}