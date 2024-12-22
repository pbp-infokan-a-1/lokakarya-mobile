import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/favorites/screens/favorites_mixin.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:lokakarya_mobile/product_page/screens/product_detail.dart';
import 'package:provider/provider.dart';

import '/models/product_entry.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> with FavoriteMixin {
  Set<String> favoriteProductIds = {};
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() => _isFetching = true);
    try {
      final ids = await fetchFavoriteIds(context);
      setState(() {
        favoriteProductIds = ids;
      });
    } finally {
      setState(() => _isFetching = false);
    }
  }

  Future<void> _handleFavoriteToggle(String productId) async {
    if (_isLoading) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to add favorites.")),
      );
      return;
    }

    final isFavorited = favoriteProductIds.contains(productId);
    setState(() => _isLoading = true);

    try {
      await toggleFavorite(context, productId, isFavorited);
      setState(() {
        if (isFavorited) {
          favoriteProductIds.remove(productId);
        } else {
          favoriteProductIds.add(productId);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isFavorited ? "Removed from favorites." : "Added to favorites."),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update favorite: $error"),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildProductCard(BuildContext context, ProductEntry product) {
    const String BASE_URL = 'http://127.0.0.1:8000/static/';
    final bool isFavorite = favoriteProductIds.contains(product.pk.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          height: 150, // Adjust as needed for responsiveness
          child: Row(
            children: [
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0), // Spacing between details and image
              // Product Image with Favorite Icon Overlay
              Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: product.fields.image != null
                          ? '$BASE_URL${product.fields.image}'
                          : 'https://via.placeholder.com/150',
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey),
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
                        onTap: _isLoading
                            ? null
                            : () =>
                                _handleFavoriteToggle(product.pk.toString()),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey[700],
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductEntryProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading || _isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.error != null) {
          return Center(
            child: Text(
              'Error: ${productProvider.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (productProvider.filteredProducts.isEmpty) {
          return Center(
            child: Text(
              productProvider.searchQuery.isEmpty
                  ? 'No products available.'
                  : 'No products match your search.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: productProvider.filteredProducts.length,
            itemBuilder: (context, index) {
              final ProductEntry product =
                  productProvider.filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  ).then((_) =>
                      _fetchFavorites()); // Refresh favorites after returning
                },
                child: _buildProductCard(context, product),
              );
            },
          );
        }
      },
    );
  }
}
