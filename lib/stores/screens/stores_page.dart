import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/stores/screens/stores_detail.dart';
import 'package:lokakarya_mobile/stores/screens/stores_edit.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/stores/models/stores_entry.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  List<StoresModel> stores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final request = CookieRequest(); 
      await fetchStores(request);
    });
  }

  Future<void> fetchStores(CookieRequest request) async {
    const link = 'http://localhost:8000/toko/show_all/';

    try {
      final response = await request.get(link);
      if (response != null) {
        final List<StoresModel> fetchedStores = (response as List)
            .map((item) => StoresModel.fromJson(item))
            .toList();

        setState(() {
          stores = fetchedStores;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memuat data toko')),
          );
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> deleteStore(CookieRequest request, int storeId) async {
    final url = 'http://localhost:8000/toko/api/$storeId/delete/';

    try {
      final response = await request.get(url);
      if (response != null) {
        setState(() {
          stores.removeWhere((store) => store.id == storeId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Toko berhasil dihapus')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus toko')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      }
    }
  }

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    const String baseUrl = 'http://localhost:8000/toko/fetch-image/';

    // Ambil status superuser dari AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isSuperuser = authProvider.isSuperuser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Stores'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                final imageUrl = '$baseUrl${store.id}/';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                store.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isSuperuser) // Gunakan isSuperuser dari provider
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoresEdit(store: store),
                                        ),
                                      );
                                      if (result == true) {
                                        fetchStores(request);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () async {
                                      final confirm = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Konfirmasi'),
                                          content: const Text('Apakah Anda yakin ingin menghapus toko ini?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Batal'),
                                              onPressed: () => Navigator.of(context).pop(false),
                                            ),
                                            TextButton(
                                              child: const Text('Hapus'),
                                              onPressed: () => Navigator.of(context).pop(true),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await deleteStore(request, store.id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Open: ${hariBukaValues.reverse[store.hariBuka]}'),
                        const SizedBox(height: 4),
                        Text(store.alamat),
                        const SizedBox(height: 4),
                        Text('Email: ${store.email}'),
                        const SizedBox(height: 4),
                        Text('Phone: ${store.telepon}'),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Text('No Image Available'),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.shopping_bag),
                                label: const Text('Lihat Produk'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoresProductDetail(
                                        store: store,
                                        isSuperuser: isSuperuser, 
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (store.gmapsLink.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.location_on),
                            label: const Text('View on Maps'),
                            onPressed: () {                            
                            final url = store.gmapsLink.isNotEmpty
                                ? store.gmapsLink
                                : 'https://www.google.com/search?q=${Uri.encodeComponent(store.nama)}';
                            _launchURL(url);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: isSuperuser 
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StoresEdit(),
                  ),
                );
                if (result == true) {
                  fetchStores(request);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}


