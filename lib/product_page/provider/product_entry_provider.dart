import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lokakarya_mobile/models/category.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/models/rating.dart';
import 'package:lokakarya_mobile/models/store_entry.dart';

enum SortOption {
  Category,
  Rating,
  AlphabetAZ,
  AlphabetZA,
}

class ProductEntryProvider with ChangeNotifier {
  List<ProductEntry> _products = [];
  List<StoreEntry> _allStores = [];
  String _searchQuery = '';
  Map<String, ProductEntry> _productDetails = {};
  Set<int> _selectedCategoryIds = {};
  SortOption? _selectedSortOption;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ProductEntry> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  Set<int> get selectedCategoryIds => _selectedCategoryIds;
  SortOption? get selectedSortOption => _selectedSortOption;

  // Filtered and Sorted Products
  List<ProductEntry> get filteredProducts {
    List<ProductEntry> tempProducts = _products;

    // Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.fields.name.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply Category Filter (OR Logic)
    if (_selectedCategoryIds.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return _selectedCategoryIds.contains(product.fields.category.pk);
      }).toList();
    }

    // Apply Sorting
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
    } else {
      // Default Sorting: By Primary Key
      tempProducts.sort((a, b) => a.pk.compareTo(b.pk));
    }

    return tempProducts;
  }

  // Fetch Products from Backend
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

  // Update Search Query
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  // Update Selected Categories (Multiple)
  void setSelectedCategories(Set<int> categoryIds) {
    _selectedCategoryIds = categoryIds;
    notifyListeners();
  }

  // Toggle Category Selection
  void toggleCategorySelection(int categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    notifyListeners();
  }

  // Update Sort Option (Single)
  void setSortOption(SortOption? option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  List<StoreEntry> getStoresForProduct(ProductEntry product) {
    for (StoreEntry elemen in product.fields.store) {
      _allStores.add(elemen);
    }
    return _allStores;
  }

  // Retrieve All Unique Categories
  List<Category> getAllCategories() {
    final categories = _products.map((p) => p.fields.category).toSet().toList();
    categories.sort((a, b) => a.fields.name.compareTo(b.fields.name));
    return categories;
  }

  // Edit a Review
  Future<void> editReview(
      String productId, int reviewId, int rating, String reviewText) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://127.0.0.1:8000/api/products/$productId/edit_reviews/$reviewId/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'rating': rating,
          'review': reviewText,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final dynamic parsedJson;

        try {
          parsedJson = jsonDecode(responseBody);
        } catch (e) {
          throw Exception('Invalid JSON format for edited review.');
        }

        final updatedReview = Rating.fromJson(parsedJson);

        // Update the review in the product details
        if (_productDetails.containsKey(productId)) {
          final product = _productDetails[productId]!;
          final index = product.fields.ratings
              .indexWhere((r) => r.pk == updatedReview.pk);
          if (index != -1) {
            product.fields.ratings[index] = updatedReview;

            // Recalculate average rating
            double totalRating = 0;
            for (var r in product.fields.ratings) {
              totalRating += r.fields.rating;
            }
            product.fields.averageRating =
                totalRating / product.fields.numReviews;

            notifyListeners();
          }
        }
      } else {
        // Handle error response
        String errorMsg;
        try {
          final errorJson = jsonDecode(response.body);
          errorMsg = errorJson['error'] ?? 'Unknown error';
        } catch (e) {
          errorMsg = response.body;
        }
        throw Exception('Failed to edit review: $errorMsg');
      }
    } catch (e) {
      throw Exception('An error occurred while editing review: $e');
    }
  }
}
