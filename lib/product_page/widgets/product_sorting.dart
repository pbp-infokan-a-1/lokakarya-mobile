// lib/widgets/product_sorting.dart

import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:provider/provider.dart';

class ProductSorting extends StatelessWidget {
  const ProductSorting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductEntryProvider>(context);
    SortOption? currentSort = productProvider.selectedSortOption;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sort By:',
          style: TextStyle(fontSize: 16.0),
        ),
        DropdownButton<SortOption>(
          hint: const Text("Select Sorting"),
          value: currentSort,
          items: const [
            DropdownMenuItem<SortOption>(
              value: SortOption.Category,
              child: Text("Category"),
            ),
            DropdownMenuItem<SortOption>(
              value: SortOption.Rating,
              child: Text("Rating"),
            ),
            DropdownMenuItem<SortOption>(
              value: SortOption.AlphabetAZ,
              child: Text("Alphabet (A-Z)"),
            ),
            DropdownMenuItem<SortOption>(
              value: SortOption.AlphabetZA,
              child: Text("Alphabet (Z-A)"),
            ),
          ],
          onChanged: (SortOption? value) {
            productProvider.setSortOption(value);
          },
        ),
      ],
    );
  }
}
