import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/list_forumentry.dart';
import 'package:lokakarya_mobile/home/screens/menu.dart';
import 'package:lokakarya_mobile/widgets/bubbletab.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lokakarya_mobile/product_page/widgets/product_list.dart';
import 'package:lokakarya_mobile/profile/screens/profile.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/product_entry_provider.dart';
import '../widgets/filter_chips.dart';
import '../widgets/sort_chips.dart';

class ProductEntryPage extends StatefulWidget {
  final int? initialCategoryId; // Add this line

  const ProductEntryPage({Key? key, this.initialCategoryId}) : super(key: key);

  @override
  State<ProductEntryPage> createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  int _selectedIndex = 1;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductEntryProvider>(context, listen: false).fetchProducts();
      if (widget.initialCategoryId != null) {
        Set<int> selectedCategories = {};
        selectedCategories.add(widget.initialCategoryId!);
        Provider.of<ProductEntryProvider>(context, listen: false)
            .setSelectedCategories(selectedCategories);
      } else {
        Provider.of<ProductEntryProvider>(context, listen: false)
            .setSelectedCategories({});
      }
      _searchController.addListener(_onSearchChanged);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } else if (_selectedIndex == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    } else if (_selectedIndex == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ForumEntryPage(),
        ),
      );
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final productProvider =
          Provider.of<ProductEntryProvider>(context, listen: false);
      productProvider.updateSearchQuery(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductEntryProvider>(context);
    final allProductNames =
        productProvider.products.map((p) => p.fields.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Products...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              suggestionsCallback: (pattern) {
                if (pattern.length < 3) {
                  return const Iterable<String>.empty();
                }
                return allProductNames
                    .where((name) =>
                        name.toLowerCase().contains(pattern.toLowerCase()))
                    .take(3); // Limit to 3 suggestions
              },
              itemBuilder: (context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (String suggestion) {
                _searchController.text = suggestion;
                productProvider.updateSearchQuery(suggestion);
              },
              noItemsFoundBuilder: (context) => const ListTile(
                title: Text('No suggestions found.'),
              ),
            ),
          ),
        ),
      ),
      drawer: const LeftDrawer(),
      body: const Column(
        children: [
          SizedBox(height: 6.0),
          FilterChips(), // Category Filter Chips
          SizedBox(height: 6.0),
          SortChips(), // Sort by Chips
          SizedBox(height: 8.0),
          Expanded(child: ProductList()), // Product List
        ],
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
        isAuthenticated: true,
      ),
    );
  }
}