import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/home/menu.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/auth/screens/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2; // Profile tab index

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to Home if home tab is selected
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else if (index == 1) {
      // Handle Forum navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigating to Forum and Review...")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
        isAuthenticated: authProvider.isAuthenticated,
      ),
    );
  }
}
