import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lokakarya_mobile/favorites/screens/favorites_mixin.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with FavoriteMixin {
  List<ProductEntry> favoriteProducts = [];
  Set<String> favoriteProductIds = {};
  bool isLoading = true;
  bool _isFavoriteLoading = false; // For favorite toggle
  String? error;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final request = context.read<CookieRequest>();

      // Fetch favorites
      final favoritesResponse =
          await request.get('http://127.0.0.1:8000/favourites/json/');

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
      if (favoritesData.containsKey("favorites") &&
          favoritesData["favorites"] is List) {
        favoriteIds = (favoritesData["favorites"] as List)
            .map((fav) => fav["id"]?.toString() ?? "")
            .where((id) => id.isNotEmpty)
            .toList();
      }

      // Update favoriteProductIds set
      setState(() {
        favoriteProductIds = favoriteIds.toSet();
      });

      // Fetch all products
      final productsResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/flutterproducts/'),
        headers: {
          'Cookie': request.cookies.toString(),
          'Content-Type': 'application/json',
        },
      );

      if (productsResponse.statusCode != 200) {
        throw Exception(
            'Failed to load products: ${productsResponse.statusCode}');
      }

      // Parse products
      List<ProductEntry> allProducts =
          productEntryFromJson(productsResponse.body);

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
    setState(() {
      _isFavoriteLoading = true;
    });
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
          SnackBar(
              content: Text(
                  response['message'] ?? "Failed to remove from favorites")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isFavoriteLoading = false;
      });
    }
  }

  Future<void> _handleFavoriteToggle(String productId) async {
    await removeFavorite(productId);
  }

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://127.0.0.1:8000/static/';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      drawer: const LeftDrawer(),
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
                        final bool isFavorite =
                            favoriteProductIds.contains(product.pk.toString());

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              height:
                                  150, // Adjust as needed for responsiveness
                              child: Row(
                                children: [
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Category
                                        Text(
                                          product.fields.category.fields.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        // Product Name
                                        Text(
                                          product.fields.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8.0),
                                        // Ratings
                                        Row(
                                          children: [
                                            ...List.generate(5, (starIndex) {
                                              if (starIndex <
                                                  product
                                                      .fields.averageRating) {
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
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          12.0), // Spacing between details and image
                                  // Product Image with Favorite Icon Overlay
                                  Stack(
                                    children: [
                                      // Product Image
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          product.fields.image != null
                                              ? '$baseUrl${product.fields.image}'
                                              : 'https://via.placeholder.com/150',
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SizedBox(
                                              width: 100,
                                              height: 120,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                            Icons.broken_image,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      // Favorite Icon Overlay
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Tooltip(
                                          message: isFavorite
                                              ? 'Remove from favorites'
                                              : 'Add to favorites',
                                          child: InkWell(
                                            onTap: _isFavoriteLoading
                                                ? null
                                                : () => _handleFavoriteToggle(
                                                    product.pk.toString()),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                shape: BoxShape.circle,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFavorite
                                                    ? Colors.red
                                                    : Colors.grey[700],
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
