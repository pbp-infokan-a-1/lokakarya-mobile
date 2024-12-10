import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/auth/screens/auth_screen.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF8B4513),
            ),
            child: Column(
              children: [
                Text(
                  'LokaKarya',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Discover Jepara's Finest Crafts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Product Page'),
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text("[FEATURE] Product Page isn't implemented yet")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Store Page'),
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text("[FEATURE] Store Page isn't implemented yet")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text('Forum & Review'),
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content:
                        Text("[FEATURE] Forum & Review isn't implemented yet")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('My Favorites'),
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content:
                        Text("[FEATURE] My Favorites isn't implemented yet")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final request = context.read<CookieRequest>();
              final response = await request.logout(
                  "http://127.0.0.1:8000/auth/logout_app/");
              
              if (context.mounted) {
                if (response['status']) {
                  String message = response["message"];
                  String uname = response["username"];
                  Provider.of<AuthProvider>(context, listen: false)
                      .setAuthenticated(false);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$message Sampai jumpa, $uname.")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
} 