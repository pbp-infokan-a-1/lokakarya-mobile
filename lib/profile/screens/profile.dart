import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/list_forumentry.dart';
import 'package:lokakarya_mobile/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/home/screens/menu.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/auth/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/profile/models/profile_model.dart';
import 'dart:convert';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:lokakarya_mobile/profile/screens/edit_profile.dart';
import 'package:lokakarya_mobile/auth/screens/auth_screen.dart';
import 'package:lokakarya_mobile/profile/screens/status.dart';
import 'package:lokakarya_mobile/favorites/screens/favorites_page.dart';
import 'package:lokakarya_mobile/product_page/screens/list_products.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

  Future<List<ProfileModel>> fetchProfile(CookieRequest request) async {
    try {
      if (!request.loggedIn) {
        throw Exception('Not logged in');
      }

      final username = request.jsonData['username'];
      if (username == null) {
        throw Exception('Username not found');
      }

      final response = await request.get(
        'http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/userprofile/show-json/',
      );
      
      print("Response: $response");
      
      // Convert the response to a JSON string
      String jsonString = json.encode(response);
      
      // Parse it using the profileModelFromJson function
      List<ProfileModel> profiles = profileModelFromJson(jsonString);
      return profiles;
      
    } catch (e) {
      print("Error fetching profile: $e");
      throw e;
    }
  }

  void _onTabChange(int index) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // If not authenticated and trying to access protected tabs
      if (!authProvider.isAuthenticated && index > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
        return;
      } else {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductEntryPage()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ForumEntryPage()),
          );
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final request = context.watch<CookieRequest>();
    
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
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProfile(request),
        builder: (context, AsyncSnapshot<List<ProfileModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Create default profile if no data
          ProfileModel profile;
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Create a default profile with empty data
            profile = ProfileModel(
              model: "userprofile.profile",
              pk: 0,
              fields: Fields(
                user: int.tryParse(request.jsonData['user_id']?.toString() ?? '0') ?? 0,
                bio: "",
                location: "",
                birthDate: DateTime.now(),
                private: false,
              ),
            );
          } else {
            profile = snapshot.data![0];
          }
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Updated Profile Picture Section
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green[100],
                          border: Border.all(
                            color: const Color(0xFF8B4513),
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: profile.fields.profilePicture != null && 
                               profile.fields.profilePicture!.isNotEmpty
                            ? Image.network(
                                profile.fields.profilePicture!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar(request);
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              )
                            : _buildDefaultAvatar(request),
                      ),
                      const SizedBox(height: 12),
                      // Username
                      Text(
                        request.jsonData['username']?.toString() ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Email or other info
                      Text(
                        profile.fields.bio.isEmpty ? 'No bio added yet' : profile.fields.bio,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Edit Profile Button
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(profile: profile),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Edit profile'),
                      ),
                    ],
                  ),
                ),

                // Sections
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Inventories Section
                      const Text(
                        'Inventories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildListTile(
                        'My Favorites',
                        '',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoritesPage(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        'Support',
                        '',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("[FEATURE] Support isn't implemented yet")),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      // Preferences Section
                      const Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        'Private Account',
                        profile.fields.private,
                        onChanged: (bool value) async {
                          try {
                            final response = await request.post(
                              'http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/userprofile/profile/${request.jsonData['username']}/update_app/',
                              jsonEncode({
                                'bio': profile.fields.bio,
                                'location': profile.fields.location,
                                'birth_date': profile.fields.birthDate.toIso8601String().split('T')[0],
                                'private': value,
                              }),
                            );

                            if (response['status'] == 'success') {
                              setState(() {
                                profile.fields.private = value;
                              });
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error updating privacy setting: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      _buildListTile(
                        'Status',
                        '',
                        leading: const Icon(Icons.article),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StatusModelPage(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        'Logout',
                        '',
                        textColor: Colors.red,
                        onTap: () async {
                          final request = context.read<CookieRequest>();
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
                                MaterialPageRoute(builder: (context) => const AuthScreen()),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
        isAuthenticated: authProvider.isAuthenticated,
      ),
    );
  }

  Widget _buildListTile(String title, String trailing, {Color? textColor, Widget? leading, VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing.isNotEmpty) 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trailing,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, {Function(bool)? onChanged}) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  // Add this helper method for the default avatar
  Widget _buildDefaultAvatar(CookieRequest request) {
    return Center(
      child: Text(
        request.jsonData['username']?.toString().substring(0, 1).toUpperCase() ?? 'U',
        style: const TextStyle(
          fontSize: 32,
          color: Color(0xFF8B4513),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
