import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/favorites/screens/favorites_mixin.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:lokakarya_mobile/product_page/widgets/product_detail.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
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
    } finally {
      setState(() => _isLoading = false);
    }
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
            child: Text('Error: ${productProvider.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16)),
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
        }

        return ListView.builder(
          itemCount: productProvider.filteredProducts.length,
          itemBuilder: (context, index) {
            final ProductEntry product = productProvider.filteredProducts[index];
            final bool isFavorite = favoriteProductIds.contains(product.pk.toString());

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
                      'http://127.0.0.1:8000/static/${product.fields.image}',
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
                            return Icon(
                              starIndex < product.fields.averageRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
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
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: _isLoading 
                        ? null 
                        : () => _handleFavoriteToggle(product.pk.toString()),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    ).then((_) => _fetchFavorites()); // Refresh favorites after returning
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}


