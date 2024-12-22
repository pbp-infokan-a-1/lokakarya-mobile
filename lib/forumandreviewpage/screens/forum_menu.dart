import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/forumandreviewpage/widgets/forum_card.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/list_forumentry.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Forum", Icons.mood),
    ItemHomepage("Tambah Forum", Icons.add),
    ItemHomepage("Logout", Icons.logout),
  ];

  // Fungsi untuk menangani perubahan tab
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke halaman yang sesuai berdasarkan tab yang dipilih
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ForumEntryPage()), // Ganti dengan halaman Forum & Review
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lokakarya Mobile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome to Lokakarya Mobile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: [
                      for (var item in items) ItemCard(item),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex,
        isAuthenticated: true, // Sesuaikan dengan status login
        onTabChange: _onTabChange,
      ),
    );
  }
}
