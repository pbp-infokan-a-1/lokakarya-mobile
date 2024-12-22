// import 'package:flutter/material.dart';
// import 'package:lokakarya_mobile/forumandreviewpage/screens/list_forumentry.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'dart:convert';
// import 'package:lokakarya_mobile/forumandreviewpage/models/forum_entry.dart';

// class ForumEntryFormPage extends StatefulWidget {
//   final PostForum? forum;

//   const ForumEntryFormPage({super.key, this.forum});
//   @override
//   State<ForumEntryFormPage> createState() => _ForumEntryFormPageState();
// }

// class _ForumEntryFormPageState extends State<ForumEntryFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _title = "";
//   String _content = "";

//   @override
//   void initState() {
//     super.initState();
//     // Jika forum ada, isi form dengan data forum
//     if (widget.forum != null) {
//       _title = widget.forum!.fields.title;
//       _content = widget.forum!.fields.content;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'Forum and Review',
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: "Title",
//                     labelText: "Title",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _title = value!;
//                     });
//                   },
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return "Title tidak boleh kosong!";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: "Content",
//                     labelText: "Content",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _content = value!;
//                     });
//                   },
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return "Content tidak boleh kosong!";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           Theme.of(context).colorScheme.primary,
//                     ),
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         try {
//                           // Kirim data ke Django
//                           final response = await request.post(
//                             "http://127.0.0.1:8000/create-forum-flutter/",
//                             jsonEncode(<String, String>{
//                               'title': _title,
//                               'content': _content,
//                             }),
//                           );

//                           if (response['status'] == 'success') {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Forum baru berhasil disimpan!"),
//                               ),
//                             );
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const ForumEntryPage()),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   response['message'] ??
//                                       "Terdapat kesalahan, coba lagi.",
//                                 ),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Error: $e")),
//                           );
//                         }
//                       }
//                     },
//                     child: const Text(
//                       "Save",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/list_forumentry.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:lokakarya_mobile/forumandreviewpage/models/forum_entry.dart';

class ForumEntryFormPage extends StatefulWidget {
  final PostForum? forum; // Menambahkan parameter opsional untuk forum

  const ForumEntryFormPage({Key? key, this.forum}) : super(key: key);

  @override
  State<ForumEntryFormPage> createState() => _ForumEntryFormPageState();
}

class _ForumEntryFormPageState extends State<ForumEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";

  @override
  void initState() {
    super.initState();
    // Jika forum ada, isi form dengan data forum
    if (widget.forum != null) {
      _title = widget.forum!.fields.title;
      _content = widget.forum!.fields.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.forum == null ? 'New Forum' : 'Edit Forum'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    hintText: "Title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Title tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _content,
                  decoration: InputDecoration(
                    hintText: "Content",
                    labelText: "Content",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _content = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Content tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.forum != null) {
                          await _updateForum(request);
                        } else {
                          await _createForum(request);
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateForum(CookieRequest request) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/edit/${widget.forum!.pk}/',
        jsonEncode(<String, String>{
          'title': _title,
          'content': _content,
        }),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Forum updated successfully.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ForumEntryPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Error updating forum."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _createForum(CookieRequest request) async {
    try {
      final response = await request.post(
        "http://127.0.0.1:8000/create-forum-flutter/",
        jsonEncode(<String, String>{
          'title': _title,
          'content': _content,
        }),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Forum baru berhasil disimpan!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ForumEntryPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Error creating forum."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
