import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/auth/screens/auth_screen.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/home/screens/menu.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              if (item.name == "Logout") {
                try {
                  final response = await request.logout(
                      "http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/auth/logout_app/");
                  
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
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response["message"] ?? "Logout failed")),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Network error occurred. Please try again."),
                        backgroundColor: Colors.red,
                      ),
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
              padding: EdgeInsets.all(constraints.maxWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: Colors.white,
                    size: constraints.maxWidth * 0.2,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: constraints.maxWidth * 0.08,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}