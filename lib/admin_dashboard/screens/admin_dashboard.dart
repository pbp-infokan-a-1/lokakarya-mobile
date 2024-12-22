import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/models/store_entry.dart' as storeEntry;
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/admin_dashboard/screens/product_form.dart';
import 'package:lokakarya_mobile/admin_dashboard/screens/store_form.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _showAddOptions = false;

  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/flutterproducts/');
      // print('Raw API Response: $response'); // Debug print
      
      if (response == null) {
        throw Exception('Response is null');
      }

      // Check if response is a List
      if (response is! List) {
        // print('Response type: ${response.runtimeType}'); // Debug print
        throw Exception('Expected List but got ${response.runtimeType}');
      }

      return List<ProductEntry>.from(
        response.map((product) {
          // print('Processing product: $product'); // Debug print
          return ProductEntry.fromJson(product);
        })
      );
    } catch (e, stackTrace) {
      print('Error fetching products: $e'); // Debug print
      print('Stack trace: $stackTrace'); // Debug print
      throw Exception('Failed to fetch products: $e');
    }
  }

Future<List<storeEntry.StoreEntry>> fetchStores(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/stores/');
    // print('Raw API Response: $response'); // Debug print

    // Validate response and extract the 'stores' key
    if (response == null || response['stores'] == null) {
      throw Exception('Invalid response: No stores data found');
    }

    final storesList = response['stores'];
    if (storesList is! List) {
      throw Exception('Expected List but got ${storesList.runtimeType}');
    }

    // Map the flat JSON structure to StoreEntry
    return List<storeEntry.StoreEntry>.from(
      storesList.map((store) => storeEntry.StoreEntry(
        model: storeEntry.Model.STOREPAGE_TOKO, // Default model
        pk: store['id'],
        fields: storeEntry.Fields(
          nama: store['nama'],
          hariBuka: storeEntry.hariBukaValues.map[store['hari_buka']] ?? storeEntry.HariBuka.SENIN_JUMAT,
          alamat: store['alamat'],
          email: store['email'],
          telepon: store['telepon'],
          image: store['image_url'],
          gmapsLink: store['gmaps_link'],
        ),
      )),
    );
  } catch (e, stackTrace) {
    print('Error fetching stores: $e'); // Debug print
    print('Stack trace: $stackTrace'); // Debug print
    throw Exception('Failed to fetch stores: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isSuperuser = authProvider.isSuperuser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: FutureBuilder(
        future: Future.wait([fetchProducts(request), fetchStores(request)]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          print('Snapshot state: ${snapshot.connectionState}'); // Debug print
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}'); // Debug print
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print('Snapshot data: ${snapshot.data}'); // Debug print
            final products = snapshot.data![0] as List<ProductEntry>;
            final stores = snapshot.data![1] as List<storeEntry.StoreEntry>;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        // print('Displaying product: ${product.fields.name}'); // Debug print
                        return Card(
                          child: ListTile(
                            title: Text(product.fields.name),
                            subtitle: Text(
                                'Min Price: ${product.fields.minPrice} | Max Price: ${product.fields.maxPrice}'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Stores',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final store = stores[index];
                        // print('Displaying store: ${store.fields.nama}'); // Debug print
                        return Card(
                          child: ListTile(
                            title: Text(store.fields.nama),
                            subtitle: Text('Open Days: ${store.fields.hariBuka}'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: isSuperuser 
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showAddOptions) ...[
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StoreForm()),
                      );
                    },
                    label: const Text('Add Store'),
                    icon: const Icon(Icons.store),
                    backgroundColor: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductForm()),
                      );
                    },
                    label: const Text('Add Product'),
                    icon: const Icon(Icons.add_shopping_cart),
                    backgroundColor: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                ],
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _showAddOptions = !_showAddOptions;
                    });
                  },
                  child: Icon(_showAddOptions ? Icons.close : Icons.add),
                ),
              ],
            )
          : null,
    );
  }
}
