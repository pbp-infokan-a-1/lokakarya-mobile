// lib/widgets/product_search_filter.dart

import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/models/category.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:provider/provider.dart';

class ProductSearchFilter extends StatelessWidget {
  const ProductSearchFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductEntryProvider>(context);

    // Extract unique categories from products
    final categories = <Category>[];
    for (var product in productProvider.filteredProducts) {
      if (!categories.any((c) => c.pk == product.fields.category.pk)) {
        categories.add(product.fields.category);
      }
    }

    return Column(
      children: [
        // Search Bar
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search Products',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            productProvider.updateSearchQuery(value);
          },
        ),
        const SizedBox(height: 16.0),
        // Category Dropdown
        Row(
          children: [
            const Text(
              'Filter by Category:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(width: 16.0),
            DropdownButton<int>(
              hint: const Text("Select Category"),
              value: productProvider.selectedCategoryId,
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text("All Categories"),
                ),
                ...categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.pk,
                    child: Text(category.fields.name),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                productProvider.setSelectedCategory(value);
              },
            ),
          ],
        ),
      ],
    );
  }
}
