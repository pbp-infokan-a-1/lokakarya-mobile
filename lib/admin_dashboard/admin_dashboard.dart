import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/models/store_entry.dart' as storeEntry;
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/widgets/product_form.dart';
import 'package:lokakarya_mobile/widgets/store_form.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<List<dynamic>> _fetchDataFuture;

  @override
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/flutterproducts/');
      print('Raw API Response: $response');
      
      if (response == null) {
        throw Exception('Response is null');
      }

      if (response is! List) {
        print('Response type: ${response.runtimeType}');
        throw Exception('Expected List but got ${response.runtimeType}');
      }

      return List<ProductEntry>.from(
        response.map((product) {
          print('Processing product: $product');
          return ProductEntry.fromJson(product);
        })
      );
    } catch (e, stackTrace) {
      print('Error fetching products: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<List<storeEntry.StoreEntry>> fetchStores(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/stores/');
      print('Raw API Response: $response');

      if (response == null || response['stores'] == null) {
        throw Exception('Invalid response: No stores data found');
      }

      final storesList = response['stores'];
      if (storesList is! List) {
        throw Exception('Expected List but got ${storesList.runtimeType}');
      }

      return List<storeEntry.StoreEntry>.from(
        storesList.map((store) => storeEntry.StoreEntry(
          model: storeEntry.Model.STOREPAGE_TOKO,
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
      print('Error fetching stores: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch stores: $e');
    }
  }

  Future<void> addProduct(CookieRequest request, ProductEntry product) async {
    try {
      final response = await request.post('http://127.0.0.1:8000/add_product/', {
        'name': product.fields.name,
        'min_price': product.fields.minPrice.toString(),
        'max_price': product.fields.maxPrice.toString(),
        'description': product.fields.description,
        'category': product.fields.category.toString(),
        'store': product.fields.store.join(','),
        'image': product.fields.image ?? '',
      });
      print('Add Product Response: $response');
    } catch (e, stackTrace) {
      print('Error adding product: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(CookieRequest request, ProductEntry product) async {
    try {
      final response = await request.post('http://127.0.0.1:8000/edit_product/${product.pk}/', {
        'name': product.fields.name,
        'min_price': product.fields.minPrice.toString(),
        'max_price': product.fields.maxPrice.toString(),
        'description': product.fields.description,
        'category': product.fields.category.toString(),
        'store': product.fields.store.join(','),
        'image': product.fields.image ?? '',
      });
      print('Update Product Response: $response');
    } catch (e, stackTrace) {
      print('Error updating product: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(CookieRequest request, String productId) async {
    try {
      final response = await request.post('http://127.0.0.1:8000/delete_product/$productId/', {});
      print('Delete Product Response: $response');
    } catch (e, stackTrace) {
      print('Error deleting product: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<void> addStore(CookieRequest request, storeEntry.StoreEntry store) async {
    try {
      final response = await request.post('http://127.0.0.1:8000/add_store/', {
        'nama': store.fields.nama,
        'hari_buka': store.fields.hariBuka.toString(),
        'alamat': store.fields.alamat,
        'email': store.fields.email,
        'telepon': store.fields.telepon,
        'image': store.fields.image ?? '',
        'gmaps_link': store.fields.gmapsLink,
      });
      print('Add Store Response: $response');
    } catch (e, stackTrace) {
      print('Error adding store: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to add store: $e');
    }
  }

  Future<void> updateStore(CookieRequest request, storeEntry.StoreEntry store) async {
    try {
      final response = await request.post('http://127.0.0.1:8000/edit_store/${store.pk}/', {
        'nama': store.fields.nama,
        'hari_buka': store.fields.hariBuka.toString(),
        'alamat': store.fields.alamat,
        'email': store.fields.email,
        'telepon': store.fields.telepon,
        'image': store.fields.image ?? '',
        'gmaps_link': store.fields.gmapsLink,
      });
      print('Update Store Response: $response');
    } catch (e, stackTrace) {
      print('Error updating store: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to update store: $e');
    }
  }

  Future<void> deleteStore(CookieRequest request, int storeId) async {
    try {
      final response = await request.post('http://127.0.0.1:8000/delete_store/$storeId/', {});
      print('Delete Store Response: $response');
    } catch (e, stackTrace) {
      print('Error deleting store: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to delete store: $e');
    }
  }

  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _fetchDataFuture = Future.wait([fetchProducts(request), fetchStores(request)]);
  }

  void _refreshData() {
    setState(() {
      final request = context.read<CookieRequest>();
      _fetchDataFuture = Future.wait([fetchProducts(request), fetchStores(request)]);
    });
  }

  // Your existing fetch methods remain the same

  void _showAddDialog(BuildContext context, bool isProduct) {
    showDialog(
      context: context,
      builder: (context) {
        if (isProduct) {
          return ProductForm(
            onSave: (product) async {
              final request = context.read<CookieRequest>();
              await addProduct(request, product);
              _refreshData();
            },
          );
        } else {
          return StoreForm(
            onSave: (store) async {
              final request = context.read<CookieRequest>();
              await addStore(request, store);
              _refreshData();
            },
          );
        }
      },
    );
  }

  void _showEditProductDialog(BuildContext context, ProductEntry product) {
    showDialog(
      context: context,
      builder: (context) {
        return ProductForm(
          product: product,
          onSave: (updatedProduct) async {
            final request = context.read<CookieRequest>();
            await updateProduct(request, updatedProduct);
            _refreshData();
          },
        );
      },
    );
  }

  void _showEditStoreDialog(BuildContext context, storeEntry.StoreEntry store) {
    showDialog(
      context: context,
      builder: (context) {
        return StoreForm(
          store: store,
          onSave: (updatedStore) async {
            final request = context.read<CookieRequest>();
            await updateStore(request, updatedStore);
            _refreshData();
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, bool isProduct, dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text(
          isProduct 
              ? 'Are you sure you want to delete ${item.fields.name}?'
              : 'Are you sure you want to delete ${item.fields.nama}?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final request = context.read<CookieRequest>();
              if (isProduct) {
                await deleteProduct(request, item.pk);
              } else {
                await deleteStore(request, item.pk);
              }
              Navigator.pop(context);
              _refreshData();
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isSuperuser = authProvider.isSuperuser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: FutureBuilder(
        future: _fetchDataFuture,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data![0] as List<ProductEntry>;
            final stores = snapshot.data![1] as List<storeEntry.StoreEntry>;
            
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Products',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        if (isSuperuser)
                          ElevatedButton.icon(
                            onPressed: () => _showAddDialog(context, true),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          child: ListTile(
                            title: Text(product.fields.name),
                            subtitle: Text(
                              'Min Price: ${product.fields.minPrice} | Max Price: ${product.fields.maxPrice}'
                            ),
                            trailing: isSuperuser
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _showEditProductDialog(
                                          context, 
                                          product
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _showDeleteConfirmation(
                                          context,
                                          true,
                                          product
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Stores',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        if (isSuperuser)
                          ElevatedButton.icon(
                            onPressed: () => _showAddDialog(context, false),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Store'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final store = stores[index];
                        return Card(
                          child: ListTile(
                            title: Text(store.fields.nama),
                            subtitle: Text('Open Days: ${store.fields.hariBuka}'),
                            trailing: isSuperuser
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _showEditStoreDialog(
                                          context,
                                          store
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _showDeleteConfirmation(
                                          context,
                                          false,
                                          store
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
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
    );
  }
}