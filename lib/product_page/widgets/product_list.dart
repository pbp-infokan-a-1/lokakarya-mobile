// lib/home/product_entry_body.dart

import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:lokakarya_mobile/product_page/widgets/product_detail.dart';
import 'package:provider/provider.dart';

import '/models/product_entry.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

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

              const String BASE_URL = 'http://127.0.0.1:8000/static/';
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        '$BASE_URL${product.fields.image}',
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
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
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
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Favorites feature is not available.")),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: product)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
