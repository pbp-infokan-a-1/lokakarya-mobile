// import 'package:flutter/material.dart';
// import 'package:lokakarya_mobile/forumandreviewpage/models/forum_entry.dart';
// import 'package:lokakarya_mobile/forumandreviewpage/widgets/left_drawer.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:lokakarya_mobile/forumandreviewpage/screens/forumentry_form.dart';
// import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';

// class ForumEntryPage extends StatefulWidget {
//   const ForumEntryPage({super.key});

//   @override
//   State<ForumEntryPage> createState() => _ForumEntryPageState();
// }

// class _ForumEntryPageState extends State<ForumEntryPage> {
//   Future<List<ForumEntry>> fetchForum(CookieRequest request) async {
//     final response = await request.get('http://127.0.0.1:8000/json/');

//     // Melakukan decode response menjadi bentuk json
//     var data = response;

//     // Melakukan konversi data json menjadi object ForumEntry
//     List<ForumEntry> listForum = [];
//     for (var d in data) {
//       if (d != null) {
//         listForum.add(ForumEntry.fromJson(d));
//       }
//     }
//     return listForum;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forum & Review'),
//       ),
//       drawer: const LeftDrawer(),
//       body: FutureBuilder<List<ForumEntry>>(
//   future: fetchForum(request),
//   builder: (context, AsyncSnapshot<List<ForumEntry>> snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (snapshot.hasError) {
//       return const Center(
//         child: Text(
//           'Terjadi kesalahan saat memuat forum.',
//           style: TextStyle(fontSize: 20, color: Colors.red),
//         ),
//       );
//     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//       return const Center(
//         child: Text(
//           'Belum ada forum.',
//           style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
//         ),
//       );
//     } else {
//       return ListView.builder(
//         itemCount: snapshot.data!.length,
//         itemBuilder: (_, index) {
//           final forum = snapshot.data![index];
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         radius: 16,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         forum.fields.title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     forum.fields.title,
//                     style: const TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     forum.fields.content,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(Icons.arrow_upward, size: 16),
//                         label: const Text('Vote'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).colorScheme.primary,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Text(
//                         "${forum.fields.title} comments",
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   },
// ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ForumEntryFormPage()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/forumandreviewpage/models/forum_entry.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/forumentry_form.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/forum_menu.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';

class ForumEntryPage extends StatefulWidget {
  const ForumEntryPage({super.key});

  @override
  State<ForumEntryPage> createState() => _ForumEntryPageState();
}

class _ForumEntryPageState extends State<ForumEntryPage> {
  int _selectedIndex = 2; // Index awal untuk tab Forum & Review

  Future<List<ForumEntry>> fetchForumEntry(CookieRequest request) async {
    try {
      final response = await request.get('http://10.0.2.2:8000/json/'); // Gunakan IP emulator
      List<ForumEntry> listForumEntry = [];
      for (var d in response) {
        if (d != null) {
          listForumEntry.add(ForumEntry.fromJson(d));
        }
      }
      return listForumEntry;
    } catch (e) {
      print('Error fetching forum: $e');
      rethrow; // Tetap lempar error untuk FutureBuilder
    }
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else if (index == 1) {
      // Arahkan ke halaman lain jika ada
    } else if (index == 3) {
      // Arahkan ke halaman profil atau lainnya
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum & Review'),
      ),
      drawer: BubbleTabBar(
        selectedIndex: 0,
        isAuthenticated: true, // Sesuaikan dengan status autentikasi
        onTabChange: (index) => {}, // Akan ditangani di BottomNavigationBar
      ),
      body: FutureBuilder<List<ForumEntry>>(
        future: fetchForumEntry(request),
        builder: (context, AsyncSnapshot<List<ForumEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching data: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
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
              itemBuilder: (_, index) {
                final forum = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              forum.fields.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          forum.fields.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          forum.fields.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_upward, size: 16),
                              label: const Text('Vote'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "${forum.fields.title} comments",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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
        isAuthenticated: true, // Sesuaikan autentikasi dengan konteks aplikasi Anda
        onTabChange: _onTabChange,
      ),
    );
  }
}
