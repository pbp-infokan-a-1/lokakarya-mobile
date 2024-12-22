// import 'package:flutter/material.dart';
// import 'package:lokakarya_mobile/forumandreviewpage/models/forum_entry.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:lokakarya_mobile/forumandreviewpage/screens/forumentry_form.dart';
// import 'package:lokakarya_mobile/home/menu.dart';
// import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';

// class ForumEntryPage extends StatefulWidget {
//   const ForumEntryPage({super.key});

//   @override
//   State<ForumEntryPage> createState() => _ForumEntryPageState();
// }

// class _ForumEntryPageState extends State<ForumEntryPage> {
//   int _selectedIndex = 2; // Index awal untuk tab Forum & Review

//   Future<List<PostForum>> fetchPostForum(CookieRequest request) async {
//     try {
//       final response = await request.get('http://127.0.0.1:8000/json/'); // Gunakan IP emulator
//       List<PostForum> listPostForum = [];
//       for (var d in response) {
//         if (d != null) {
//           listPostForum.add(PostForum.fromJson(d));
//         }
//       }
//       return listPostForum;
//     } catch (e) {
//       print('Error fetching forum: $e');
//       rethrow; // Tetap lempar error untuk FutureBuilder
//     }
//   }

//   void _onTabChange(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MyHomePage()),
//       );
//     } else if (index == 1) {
//       // Arahkan ke halaman lain jika ada
//     } else if (index == 3) {
//       // Arahkan ke halaman profil atau lainnya
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forum & Review'),
//       ),
//       body: FutureBuilder<List<PostForum>>(
//         future: fetchPostForum(request),
//         builder: (context, AsyncSnapshot<List<PostForum>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error fetching data: ${snapshot.error}',
//                 style: const TextStyle(fontSize: 16, color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No forum entries available.',
//                 style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
//               ),
//             );
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (_, index) {
//                 final forum = snapshot.data![index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const CircleAvatar(
//                               backgroundColor: Colors.grey,
//                               radius: 16,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               forum.fields.title,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           forum.fields.title,
//                           style: const TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           forum.fields.content,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: () {},
//                               icon: const Icon(Icons.arrow_upward, size: 16),
//                               label: const Text('Vote'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     Theme.of(context).colorScheme.primary,
//                                 foregroundColor: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Text(
//                               "${forum.fields.title} comments",
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ForumEntryFormPage()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: BubbleTabBar(
//         selectedIndex: _selectedIndex,
//         onTabChange: _onTabChange,
//         isAuthenticated: authProvider.isAuthenticated,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/forumandreviewpage/models/forum_entry.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/forumentry_form.dart';
import 'package:lokakarya_mobile/home/menu.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/product_page/screens/list_products.dart';
import 'package:lokakarya_mobile/profile/screens/profile.dart';

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
          .get('http://127.0.0.1:8000/forumjson/'); // Ganti IP sesuai server
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
    final request = context.watch<CookieRequest>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with author
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  forum.fields.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                if (forum.fields.author == request.jsonData['user_id'])
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _navigateToEditPage(forum);
                      } else if (value == 'delete') {
                        _deleteForum(forum.pk);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
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
                    // Navigate to comments page
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
    );
  }
  

  Future<void> _deleteForum(String forumId) async {
    final request = context.read<CookieRequest>();
    final response =
        await request.post('http://127.0.0.1:8000/delete/$forumId/', {});

    if (response['status'] == 'success') {
      setState(() {
        _cachedForums.removeWhere((forum) => forum.pk == forumId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Forum deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting forum.')),
      );
    }
  }

  Future<void> _upvoteForum(String forumId) async {
    final request = context.read<CookieRequest>();
    final response =
        await request.post('http://127.0.0.1:8000/upvote/$forumId/', {});

    if (response['status'] == 'success') {
      setState(() {
        final forum = _cachedForums.firstWhere((forum) => forum.pk == forumId);
        forum.fields.totalUpvotes = response['upvotes'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Forum upvoted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error upvoting forum.')),
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
