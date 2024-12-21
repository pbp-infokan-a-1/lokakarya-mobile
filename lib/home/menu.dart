import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart'; // Import the BubbleTabBar widget
//TODO: NANTI BENERIN import 'package:lokakarya_mobile/profile/profile.dart'; // Import the Profile screen

class MyHomePagez extends StatefulWidget {
  MyHomePagez({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePagez> {
  int _selectedIndex = 0; // Set Home as the default tab index

  final String npm = '5000000000'; // NPM
  final String name = 'Gedagedi Gedagedago'; // Nama
  final String className = 'PBP S'; // Kelas
  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Mood", Icons.mood),
    ItemHomepage("Tambah Mood", Icons.add),
    ItemHomepage("Logout", Icons.logout),
  ];

  // Function to handle tab changes
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to Forum & Review screen if the Profile tab is selected
    if (_selectedIndex == 1) {
      // Handle Forum and Review navigation here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigating to Forum and Review...")),
      );
    // } else if (_selectedIndex == 2) {
    //   Navigator.push(
    //     context,
    //     //TODO: NANTI BENERIN INI MaterialPageRoute(builder: (context) => const ProfileScreen()), // Navigate to Profile screen
    //   );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mental Health Tracker',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: name),
                InfoCard(title: 'Class', content: className),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome to Mental Health Tracker',
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
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex, // Pass the selected index to highlight the active tab
        onTabChange: _onTabChange, // Pass the callback to handle tab change
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You tapped ${item.name}!"))
            );
            // Navigate ke route yang sesuai (tergantung jenis tombol)
              if (item.name == "Tambah Mood") {
                // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup MoodEntryFormPage.
              }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}