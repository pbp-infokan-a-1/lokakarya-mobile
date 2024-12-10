import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/home/menu.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/auth/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/profile/models/profile_model.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

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
        'http://127.0.0.1:8000/userprofile/show-json/',
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
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigating to Forum and Review...")),
      );
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      request.jsonData['username']?.toString().substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileInfoCard(
                  title: 'Username',
                  content: request.jsonData['username']?.toString() ?? 'User',
                ),
                ProfileInfoCard(
                  title: 'Bio',
                  content: profile.fields.bio.isEmpty ? 'No bio added yet' : profile.fields.bio,
                ),
                ProfileInfoCard(
                  title: 'Location',
                  content: profile.fields.location.isEmpty ? 'No location added' : profile.fields.location,
                ),
                ProfileInfoCard(
                  title: 'Birth Date',
                  content: profile.fields.birthDate.year == DateTime.now().year ? 
                          'Not specified' : 
                          profile.fields.birthDate.toString().split(' ')[0],
                ),
                ProfileInfoCard(
                  title: 'Account Type',
                  content: profile.fields.private ? 'Private' : 'Public',
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add edit profile functionality here
                    },
                    child: const Text('Edit Profile'),
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

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String content;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
