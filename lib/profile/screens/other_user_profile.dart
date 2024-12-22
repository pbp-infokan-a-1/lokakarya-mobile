import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/profile/models/profile_model.dart';
import 'package:lokakarya_mobile/profile/screens/status.dart';
import 'dart:convert';
import 'package:lokakarya_mobile/home/screens/menu.dart';
import 'package:lokakarya_mobile/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/product_page/screens/list_products.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String username;

  const OtherUserProfileScreen({
    super.key,
    required this.username,
  });

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  int _selectedIndex = 3;  // Profile tab index

  void _onTabChange(int index) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("[FEATURE] Forum & Review isn't implemented yet")),
      );
    }
  }

  Future<ProfileModel> fetchProfile(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/userprofile/profile/${widget.username}/get/',
      );
      
      // Check if response is error
      if (response is Map && response.containsKey('error')) {
        throw Exception(response['error']);
      }
      
      // Convert the response to a JSON string
      String jsonString = json.encode(response);
      
      // Parse it using the profileModelFromJson function
      List<ProfileModel> profiles = profileModelFromJson(jsonString);
      return profiles[0];
      
    } catch (e) {
      print("Error fetching profile: $e");
      throw Exception('Profile not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final authProvider = Provider.of<AuthProvider>(context);  // Add this

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF8B4513),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: fetchProfile(request),
        builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Profile not found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          final profile = snapshot.data!;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Profile Picture
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
                        child: Center(
                          child: Text(
                            widget.username[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              color: Color(0xFF8B4513),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Username
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TTMoons',
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Bio
                      Text(
                        profile.fields.bio.isEmpty ? 'No bio added yet' : profile.fields.bio,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Status Section
                if (!profile.fields.private) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatusModelPage(
                              username: widget.username,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'View Status',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],

                // Private Account Notice
                if (profile.fields.private)
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'This Account is Private',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Follow this account to see their status and activities.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
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
} 