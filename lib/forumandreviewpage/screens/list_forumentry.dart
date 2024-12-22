import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/forumandreviewpage/models/forum_entry.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/forumentry_form.dart';
import 'package:lokakarya_mobile/home/menu.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/product_page/screens/list_products.dart';
import 'package:lokakarya_mobile/profile/screens/profile.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/comment_page.dart';

class ForumEntryPage extends StatefulWidget {
  const ForumEntryPage({super.key});

  @override
  State<ForumEntryPage> createState() => _ForumEntryPageState();
}

class _ForumEntryPageState extends State<ForumEntryPage> {
  int _selectedIndex = 2; // Index awal untuk tab Forum & Review
  List<PostForum> _cachedForums = []; // Cache forum

  Future<List<PostForum>> fetchPostForum(CookieRequest request) async {
    try {
      final response = await request
          .get('http://127.0.0.1:8000/json/'); // Ganti IP sesuai server
      List<PostForum> listPostForum = [];
      for (var d in response) {
        if (d != null) {
          listPostForum.add(PostForum.fromJson(d));
        }
      }
      _cachedForums = listPostForum; // Update cache
      return listPostForum;
    } catch (e) {
      print('Error fetching forum: $e');
      // Jika terjadi error, gunakan cache terakhir
      if (_cachedForums.isNotEmpty) {
        return _cachedForums;
      }
      rethrow;
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProductEntryPage(),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    }
  }

  Widget _buildForumCard(PostForum forum) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  forum.fields.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEditPage(forum); // Edit action
                    } else if (value == 'delete') {
                      _confirmDelete(forum.pk); // Delete action with confirmation
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Content
            Text(
              forum.fields.content,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Actions (Upvote and Comments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _upvoteForum(forum.pk),
                  icon: const Icon(Icons.thumb_up),
                  label: Text('${forum.fields.totalUpvotes}'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsPage(forum: forum),
                      ),
                    );
                  },
                  child: const Text('Comments'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditPage(PostForum forum) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForumEntryFormPage(forum: forum),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {}); // Refresh data setelah kembali
      }
    });
  }

  Future<void> _deleteForum(String forumId) async {
    final request = context.read<CookieRequest>();
    final response = await request.post(
      'http://127.0.0.1:8000/delete/$forumId/',
      {}, // Payload kosong untuk DELETE
    );

    if (response['status'] == 'success') {
      setState(() {
        _cachedForums.removeWhere((forum) => forum.pk == forumId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Forum deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error deleting forum.')),
      );
    }
  }

  void _confirmDelete(String forumId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this forum?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteForum(forumId); // Jalankan fungsi delete
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _upvoteForum(String forumId) async {
    final request = context.read<CookieRequest>();
    final response = await request.post(
      'http://127.0.0.1:8000/upvote/$forumId/',
      {}, // Payload kosong untuk POST
    );

    if (response['status'] == 'success') {
      setState(() {
        final forum = _cachedForums.firstWhere((forum) => forum.pk == forumId);
        forum.fields.totalUpvotes += 1; // Tambahkan +1 pada upvotes
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Forum upvoted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error upvoting forum.')),
      );
    }
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum & Review'),
      ),
      body: FutureBuilder<List<PostForum>>(
        future: fetchPostForum(request),
        builder: (context, AsyncSnapshot<List<PostForum>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorMessage('Error fetching data: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No forum entries available.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => _buildForumCard(snapshot.data![index]),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForumEntryFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
        isAuthenticated: request.loggedIn,
      ),
    );
  }
}