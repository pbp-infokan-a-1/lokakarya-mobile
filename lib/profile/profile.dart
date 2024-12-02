import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart'; // Import the BubbleTabBar widget
import 'package:lokakarya_mobile/home/menu.dart'; // Import the Menu (Home) screen for other tab navigation

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 1; // Profile is selected by default

  // Handle tab changes
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen based on the selected tab
    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()), // Navigate to Home
      );
    } else if (_selectedIndex == 1) {
      // Stay on the profile screen
    } else if (_selectedIndex == 2) {
      // Handle Forum and Review navigation here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigating to Forum and Review...")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Display the content for the profile screen
            Center(
              child: Column(
                children: const [
                  Text(
                    "This is UserProfile screen",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("User profile details can be shown here."),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex, // Pass the selected index to the BubbleTabBar
        onTabChange: _onTabChange, // Handle the tab change here
      ),
    );
  }
}
