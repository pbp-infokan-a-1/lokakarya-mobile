import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/profile/models/status_model.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'add_status.dart';
import 'package:http/http.dart' as http;

class StatusModelPage extends StatefulWidget {
  final String? username;

  const StatusModelPage({
    super.key,
    this.username,
  });

  @override
  State<StatusModelPage> createState() => _StatusModelPageState();
}

class _StatusModelPageState extends State<StatusModelPage> {
  Future<List<StatusModel>> fetchStatus(CookieRequest request) async {
    final response = await request.get(
      widget.username != null
          ? 'http://127.0.0.1:8000/userprofile/profile/${widget.username}/status/'
          : 'http://127.0.0.1:8000/userprofile/profile/${request.jsonData['username']}/status/',
    );
    var data = response;

    List<StatusModel> listStatus = [];
    for (var d in data) {
      if (d != null) {
        listStatus.add(StatusModel.fromJson(d));
      }
    }
    return listStatus;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isOwnProfile = widget.username == null || 
                        widget.username == request.jsonData['username'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isOwnProfile ? 'My Status' : "${widget.username}'s Status",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8B4513),
      ),
      drawer: isOwnProfile ? const LeftDrawer() : null,
      body: FutureBuilder(
        future: fetchStatus(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada status pada profile anda.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final status = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${status.fields.title}",
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${status.fields.description}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: isOwnProfile ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStatusScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF8B4513),
      ) : null,
    );
  }
}