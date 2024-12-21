import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/favorites/screens/favorites_page.dart';
import 'package:lokakarya_mobile/product_page/screens/list_products.dart';
import 'package:lokakarya_mobile/stores/screens/stores_page.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/home/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/auth/screens/auth_screen.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Provider.of<AuthProvider>(context).isAuthenticated;

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF8B4513),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Image(
                    image: AssetImage('assets/images/logo_lokakarya.png'),
                    height: 50,
                    fit: BoxFit.contain,
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
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Product Page'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductEntryPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Store Page'),
            onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoresPage()),
                );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(isAuthenticated ? 'Logout' : 'Login'),
            onTap: () async {
              if (isAuthenticated) {
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
              } else {
                // Navigate to login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
} 