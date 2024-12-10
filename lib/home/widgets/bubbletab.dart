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
    // Ensure selected index is valid
    final validIndex = selectedIndex < (isAuthenticated ? 3 : 2) ? selectedIndex : 0;
    
    return BottomNavigationBar(
      currentIndex: validIndex,
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
