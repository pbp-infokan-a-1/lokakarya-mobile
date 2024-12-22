import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/home/screens/menu.dart';
import 'package:lokakarya_mobile/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/models/rating.dart';
import 'package:lokakarya_mobile/models/store_entry.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:lokakarya_mobile/product_page/widgets/review.dart';
import 'package:lokakarya_mobile/product_page/widgets/star_rating.dart';
import 'package:lokakarya_mobile/profile/screens/profile.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntry product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedIndex = 1;
  // List of Ratings and Store for the product
  List<Rating> _ratings = [];
  List<StoreEntry> _stores = [];

  // Scroll Controller for detecting scroll position
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _initializeRatings();
    _stores = Provider.of<ProductEntryProvider>(context, listen: false)
        .getStoresForProduct(widget.product);
  }

  void _initializeRatings() {
    // Initialize _ratings from the product's existing ratings
    _ratings = List<Rating>.from(widget.product.fields.ratings);
  }

  void _scrollListener() {
    // Optional: If you have a reason to adjust UI elements based on scroll offset
    double maxScroll = 250.0;
    double currentScroll = _scrollController.offset;

    double newOpacity = (currentScroll / maxScroll).clamp(0.0, 1.0);

    setState(() {
      _opacity = newOpacity;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else if (_selectedIndex == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  void _updateReview(Rating updatedReview) {
    setState(() {
      int index = _ratings.indexWhere((r) => r.pk == updatedReview.pk);
      if (index != -1) {
        _ratings[index] = updatedReview;

        // Recompute averageRating
        double totalRating =
            _ratings.fold(0.0, (sum, r) => sum + r.fields.rating);
        widget.product.fields.averageRating = totalRating / _ratings.length;
      }
    });
  }

  void _removeReview(int reviewId) {
    setState(() {
      _ratings.removeWhere((r) => r.pk == reviewId);

      // Recompute averageRating and numReviews
      if (_ratings.isNotEmpty) {
        double totalRating =
            _ratings.fold(0.0, (sum, r) => sum + r.fields.rating);
        widget.product.fields.averageRating = totalRating / _ratings.length;
        widget.product.fields.numReviews = _ratings.length;
      } else {
        widget.product.fields.averageRating = 0.0;
        widget.product.fields.numReviews = 0;
      }
    });
  }

  // Function to show the Add Review Popup Dialog
  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int _localSelectedRating = 0;
        final TextEditingController _localReviewController =
            TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool _isSubmitting = false; // Manage loading state

            return AlertDialog(
              title: const Text('Add Review'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Star Rating Widget
                    StarRatingWidget(
                      onRatingSelected: (rating) {
                        setState(() {
                          _localSelectedRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    // Review Text
                    TextField(
                      controller: _localReviewController,
                      decoration: const InputDecoration(
                        labelText: 'Your Review (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          Navigator.of(context).pop(); // Cancel
                        },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          // Validate the form
                          if (_localSelectedRating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please select a rating.")),
                            );
                            return;
                          }

                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          if (!authProvider.isAuthenticated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Please log in to add a review.")),
                            );
                            return;
                          }

                          final reviewText = _localReviewController.text.trim();
                          final productId = widget.product.pk.toString();

                          setState(() {
                            _isSubmitting = true;
                          });

                          try {
                            final request = context.read<CookieRequest>();
                            final response = await request.postJson(
                              'http://127.0.0.1:8000/api/products/$productId/reviews/',
                              jsonEncode({
                                'rating': _localSelectedRating,
                                'review': reviewText,
                              }),
                            );

                            if (response.containsKey('pk')) {
                              // Successfully added
                              final newReview = Rating.fromJson(response);

                              setState(() {
                                _ratings.insert(0, newReview);
                                widget.product.fields.numReviews += 1;
                                widget.product.fields.averageRating = ((widget
                                                .product.fields.averageRating *
                                            (widget.product.fields.numReviews -
                                                1)) +
                                        newReview.fields.rating) /
                                    widget.product.fields.numReviews;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Review added successfully.")),
                              );
                              Navigator.of(context).pop(); // Close dialog
                            } else if (response.containsKey('error')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Failed to add review: ${response['error']}")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Failed to add review.")),
                              );
                            }
                          } catch (e) {
                            // Handle any other errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("An error occurred: $e")),
                            );
                          }

                          // Clear inputs
                          _localReviewController.clear();
                          setState(() {
                            _localSelectedRating = 0;
                            _isSubmitting = false;
                          });
                        },
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductEntryProvider>(context);
    final similarProducts = productProvider.filteredProducts
        .where((p) =>
            p.fields.category.pk == widget.product.fields.category.pk &&
            p.pk != widget.product.pk)
        .take(7)
        .toList();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuthenticated = authProvider.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        // Only set elevation if you'd like the AppBar to have a shadow after a certain scroll offset
        elevation: _opacity > 0.5 ? 4.0 : 0.0,
      ),
      drawer: const LeftDrawer(),

      // A SingleChildScrollView to allow vertical scrolling of the entire page
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Image Section: Expand or AspectRatio to display the image
            CachedNetworkImage(
              imageUrl: widget.product.fields.image != null
                  ? 'http://127.0.0.1:8000/static/${widget.product.fields.image}'
                  : 'assets/images/placeholder_image.png',
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(
                Icons.broken_image,
                size: 100,
                color: Colors.grey,
              ),
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),

            // Information Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name & Favorites Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.fields.name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.pink,
                          size: 30.0,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Added to favorites (placeholder).")),
                          );
                        },
                        tooltip: 'Add to Favorites',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Category
                  Text(
                    widget.product.fields.category.fields.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Description
                  Text(
                    widget.product.fields.description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),

                  // Average Rating and Number of Ratings
                  Row(
                    children: [
                      // Display stars based on average rating
                      Row(
                        children: List.generate(5, (index) {
                          if (index <
                              widget.product.fields.averageRating.round()) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20.0,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              color: Colors.amber,
                              size: 20.0,
                            );
                          }
                        }),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.product.fields.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        '(${widget.product.fields.numReviews} Reviews)',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Price Range
                  Text(
                    'Price: Rp. ${widget.product.fields.minPrice.toStringAsFixed(2)} - Rp. ${widget.product.fields.maxPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Affiliated Stores',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Iterate over the list of stores
                          for (StoreEntry store
                              in widget.product.fields.store) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        store.fields.nama,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        store.fields.alamat,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'http://127.0.0.1:8000/static/${store.fields.image}',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Reviews
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Reviews Header + Add Review Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Customer Reviews',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Replace IconButton with a TextButton
                              ElevatedButton(
                                onPressed: isAuthenticated
                                    ? () {
                                        // Show the Add Review dialog
                                        _showAddReviewDialog(context);
                                      }
                                    : null, // Disable button if not authenticated
                                child: const Text(
                                  'Add Review',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (!isAuthenticated)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "You must log in to leave a review.",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16.0),

                          // Reviews Content
                          _ratings.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "No reviews yet.",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Image.asset(
                                        'assets/images/no_review_placeholder.png',
                                        width: 180,
                                        height: 180,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 220.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _ratings.length,
                                    itemBuilder: (context, index) {
                                      final review = _ratings[index];
                                      return ReviewWidget(
                                        review: review,
                                        productId: widget.product.pk.toString(),
                                        date:
                                            review.fields.createdAt.toString(),
                                        onReviewEdited: _updateReview,
                                        onReviewDeleted: _removeReview,
                                      );
                                    },
                                  ),
                                ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Recommended Section
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You May Also Like',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height:
                                250.0, // Height for the horizontal list of similar products
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: similarProducts.length,
                              itemBuilder: (context, index) {
                                final similarProduct = similarProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailPage(
                                            product: similarProduct),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 200.0,
                                    margin: const EdgeInsets.only(right: 12.0),
                                    child: Stack(
                                      children: [
                                        // Product Card with Image
                                        Card(
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: CachedNetworkImage(
                                              imageUrl: similarProduct
                                                          .fields.image !=
                                                      null
                                                  ? 'http://127.0.0.1:8000/static/${similarProduct.fields.image}'
                                                  : 'assets/images/placeholder_image.png',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.broken_image,
                                                size: 100.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Overlay with Product Name and Price
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.9),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(12.0),
                                                bottomRight:
                                                    Radius.circular(12.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  similarProduct.fields.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  'Rp. ${similarProduct.fields.minPrice.toStringAsFixed(2)} - Rp. ${similarProduct.fields.maxPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
        isAuthenticated: isAuthenticated, // Pass authentication state if needed
      ),
    );
  }
}
