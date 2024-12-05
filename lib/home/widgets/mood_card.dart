import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/auth/screens/login.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';

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
    final request = context.watch<CookieRequest>();
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          if (item.name == "Logout") {
            final response = await request.logout(
                "http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/auth/logout_app/");
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                Provider.of<AuthProvider>(context, listen: false)
                    .setAuthenticated(false);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$message Sampai jumpa, $uname.")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            }
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text("You tapped ${item.name}!")),
              );
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