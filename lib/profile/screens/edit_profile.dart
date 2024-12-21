import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:lokakarya_mobile/profile/models/profile_model.dart';
import 'package:lokakarya_mobile/profile/screens/profile.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;
  
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  late bool _isPrivate;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.profile.fields.bio);
    _locationController = TextEditingController(text: widget.profile.fields.location);
    _selectedDate = widget.profile.fields.birthDate;
    _isPrivate = widget.profile.fields.private;
  }

  @override
  void dispose() {
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF8B4513).withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/bg_login.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0xFF8B4513).withOpacity(0.2),
              BlendMode.multiply,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                color: const Color(0xFFFFF8DC),  // Cream color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bio Section
                        const Text(
                          'Bio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _bioController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Tell us about yourself',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Location Section
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your location',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Birth Date Section
                        const Text(
                          'Birth Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_selectedDate.toLocal()}".split(' ')[0],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.calendar_today, color: Color(0xFF8B4513)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Private Account Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Private Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                            Switch(
                              value: _isPrivate,
                              onChanged: (bool value) {
                                setState(() {
                                  _isPrivate = value;
                                });
                              },
                              activeColor: const Color(0xFF8B4513),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                print('Sending data: ${jsonEncode({
                                  'bio': _bioController.text,
                                  'location': _locationController.text,
                                  'birth_date': _selectedDate.toIso8601String().split('T')[0],
                                  'private': _isPrivate,
                                  'user': widget.profile.fields.user,
                                })}');
                                final response = await request.post(
                                  'http://127.0.0.1:8000/userprofile/profile/${request.jsonData['username']}/update_app/',
                                  jsonEncode({
                                    'bio': _bioController.text,
                                    'location': _locationController.text,
                                    'birth_date': _selectedDate.toIso8601String().split('T')[0],
                                    'private': _isPrivate,
                                    'user': widget.profile.fields.user,
                                  }),
                                );

                                if (response['status'] == 'success') {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Profile updated successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ProfileScreen(),
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(response['message'] ?? 'Failed to update profile'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                print('Error updating profile: $e');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error updating profile: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B4513),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'GaleySemibold',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 