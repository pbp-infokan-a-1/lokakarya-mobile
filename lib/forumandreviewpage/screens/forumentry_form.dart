import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/list_forumentry.dart';

class ForumEntryFormPage extends StatefulWidget {
  const ForumEntryFormPage({super.key});
  @override
  State<ForumEntryFormPage> createState() => _ForumEntryFormPageState();
}

class _ForumEntryFormPageState extends State<ForumEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum & Review'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Drafts',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Post',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter title (max 300 characters)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  counterText: "",
                ),
                maxLength: 300,
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'Write your content here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _content = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Content cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Redirect to home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Post submission logic
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForumEntryPage(),
                          ),
                        );
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Post Successful'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Title: $_title'),
                                    Text('Content: $_content'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _title = "";
                                      _content = "";
                                    });
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                    ),
                    child: const Text('Post'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
