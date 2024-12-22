import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:provider/provider.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductEntryProvider>(context);
    final categories = productProvider.getAllCategories();

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Category:',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected =
                    productProvider.selectedCategoryIds.contains(category.pk);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category.fields.name),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      productProvider.toggleCategorySelection(category.pk);
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.grey[300],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
