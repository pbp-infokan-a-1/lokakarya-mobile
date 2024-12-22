import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:lokakarya_mobile/product_page/screens/product_detail.dart';
import 'package:provider/provider.dart';

import '/models/product_entry.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  Widget _buildProductCard(BuildContext context, ProductEntry product) {
    const String BASE_URL = 'http://127.0.0.1:8000/static/';
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
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (productProvider.error != null) {
          return Center(
            child: Text(
              'Error: ${productProvider.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (productProvider.filteredProducts.isEmpty) {
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
                  );
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
