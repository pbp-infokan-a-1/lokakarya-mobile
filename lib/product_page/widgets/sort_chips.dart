import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:provider/provider.dart';

class SortChips extends StatelessWidget {
  const SortChips({Key? key}) : super(key: key);

  String _getSortOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.Rating:
        return 'Rating';
      case SortOption.AlphabetAZ:
        return 'Alphabet (A-Z)';
      case SortOption.AlphabetZA:
        return 'Alphabet (Z-A)';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductEntryProvider>(context);
    final sortOptions = SortOption.values
        .where((option) => option != SortOption.Category)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort By:',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: sortOptions.map((sortOption) {
                final isSelected =
                    productProvider.selectedSortOption == sortOption;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_getSortOptionLabel(sortOption)),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        productProvider.setSortOption(sortOption);
                      } else {
                        productProvider.setSortOption(null);
                      }
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
