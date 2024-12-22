
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/product_page/screens/product_detail.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<ProductEntry> favoriteProducts = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      final request = context.read<CookieRequest>();
      
      // Fetch favorites
      final favoritesResponse = await request.get('http://127.0.0.1:8000/favourites/json/');
      
      // Parse favorites response
      Map<String, dynamic> favoritesData;
      if (favoritesResponse is String) {
        favoritesData = jsonDecode(favoritesResponse);
      } else if (favoritesResponse is Map) {
        favoritesData = Map<String, dynamic>.from(favoritesResponse);
      } else {
        throw Exception("Unexpected favorites response format");
      }

      // Extract favorite IDs
      List<String> favoriteIds = [];
      if (favoritesData.containsKey("favorites") && favoritesData["favorites"] is List) {
        favoriteIds = (favoritesData["favorites"] as List)
            .map((fav) => fav["id"]?.toString() ?? "")
            .where((id) => id.isNotEmpty)
            .toList();
      }

      // Fetch all products
      final productsResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/flutterproducts/'),
        headers: {
          'Cookie': request.cookies.toString(),
          'Content-Type': 'application/json',
        },
      );

      if (productsResponse.statusCode != 200) {
        throw Exception('Failed to load products: ${productsResponse.statusCode}');
      }

      // Parse products
      List<ProductEntry> allProducts = productEntryFromJson(productsResponse.body);
      
      // Filter products that are in favorites
      List<ProductEntry> filteredProducts = allProducts
          .where((product) => favoriteIds.contains(product.pk.toString()))
          .toList();

      setState(() {
        favoriteProducts = filteredProducts;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading favorites: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> removeFavorite(String productId) async {
    try {
      final request = context.read<CookieRequest>();
      
      final response = await request.post(
        'http://127.0.0.1:8000/favourites/remove/',
        jsonEncode({
          "product_id": productId,
        }),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully removed from favorites")),
        );
        // Refresh the favorites list
        await fetchAllData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Failed to remove from favorites")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://127.0.0.1:8000/static/';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      drawer: LeftDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : favoriteProducts.isEmpty
                  ? Center(
                      child: Text(
                        'No favorite products available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: favoriteProducts.length,
                      itemBuilder: (context, index) {
                        final product = favoriteProducts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  '$baseUrl${product.fields.image}',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                product.fields.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$${product.fields.minPrice.toStringAsFixed(2)} - \$${product.fields.maxPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      ...List.generate(5, (starIndex) {
                                        if (starIndex < product.fields.averageRating) {
                                          return const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                                        } else {
                                          return const Icon(
                                            Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                                        }
                                      }),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${product.fields.numReviews})',
                                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.red),
                                onPressed: () async {
                                  await removeFavorite(product.pk.toString());
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(product: product),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}



