import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lokakarya_mobile/models/product_entry.dart';

enum SortOption {
  Category,
  Rating,
  AlphabetAZ,
  AlphabetZA,
}

class ProductEntryProvider with ChangeNotifier {
  List<ProductEntry> _products = [];
  List<ProductEntry> _filteredProducts = [];
  String _searchQuery = '';
  int? _selectedCategoryId;
  SortOption? _selectedSortOption;
  bool _isLoading = false;
  String? _error;

  List<ProductEntry> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  int? get selectedCategoryId => _selectedCategoryId;
  SortOption? get selectedSortOption => _selectedSortOption;

  List<ProductEntry> get filteredProducts {
    List<ProductEntry> tempProducts = _products;

    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.fields.name.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    if (_selectedCategoryId != null) {
      tempProducts = tempProducts.where((product) {
        return product.fields.category.pk == _selectedCategoryId;
      }).toList();
    }

    if (_selectedSortOption != null) {
      switch (_selectedSortOption!) {
        case SortOption.Category:
          tempProducts.sort((a, b) => a.fields.category.fields.name
              .compareTo(b.fields.category.fields.name));
          break;
        case SortOption.Rating:
          tempProducts.sort((a, b) {
            if (b.fields.averageRating != a.fields.averageRating) {
              return b.fields.averageRating.compareTo(a.fields.averageRating);
            } else {
              return b.fields.numReviews.compareTo(a.fields.numReviews);
            }
          });
          break;
        case SortOption.AlphabetAZ:
          tempProducts.sort((a, b) => a.fields.name.compareTo(b.fields.name));
          break;
        case SortOption.AlphabetZA:
          tempProducts.sort((a, b) => b.fields.name.compareTo(a.fields.name));
          break;
      }
    }

    return tempProducts;
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/flutterproducts/'),
      );

      if (response.statusCode == 200) {
        _products = productEntryFromJson(response.body);
        if (_products.isEmpty) {
          _error = 'No products found.';
        }
      } else {
        _error = 'Failed to load products: ${response.statusCode}';
        _products = [];
      }
    } catch (e) {
      _error = 'An error occurred: $e';
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }

  void setSelectedCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSortOption(SortOption? option) {
    _selectedSortOption = option;
    notifyListeners();
  }
}
