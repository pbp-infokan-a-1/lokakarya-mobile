import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:lokakarya_mobile/product_page/widgets/review.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/favorites/screens/favorites_mixin.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntry product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>  with FavoriteMixin {
  final _reviewController = TextEditingController();
  int _selectedRating = 5;
  int _currentPage = 0; // For page indicators
  bool _isFavorite = false;
  bool _isLoading = true;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _checkFavoriteStatus();
  }

    Future<void> _checkFavoriteStatus() async {
    final isFav = await checkIsFavorite(context, widget.product.pk.toString());
    setState(() {
      _isFavorite = isFav;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _addReview(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to add a review.")),
      );
      return;
    }

    final reviewText = _reviewController.text.trim();
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review cannot be empty.")),
      );
      return;
    }

    // TODO: Implement API call to submit the review to the backend

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Review added successfully.")),
    );
  }




  Future<void> _handleFavoriteToggle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to add favorites.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await toggleFavorite(context, widget.product.pk.toString(), _isFavorite);
      setState(() => _isFavorite = !_isFavorite);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final similarProducts = Provider.of<ProductEntryProvider>(context)
        .filteredProducts
        .where((p) =>
            p.fields.category.pk == widget.product.fields.category.pk &&
            p.pk != widget.product.pk)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.fields.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: CachedNetworkImage(
                imageUrl:
                    'http://127.0.0.1:8000/static/${widget.product.fields.image}',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Product Category
            Text(
              widget.product.fields.category.fields.name,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // Product Name
            Text(
              widget.product.fields.name,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // Product Description
            Text(
              widget.product.fields.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            // Rating and Reviews
            Row(
              children: [
                // Star Rating
                Row(
                  children: List.generate(5, (index) {
                    if (index < widget.product.fields.averageRating.round()) {
                      return const Icon(Icons.star, color: Colors.amber);
                    } else {
                      return const Icon(Icons.star_border, color: Colors.amber);
                    }
                  }),
                ),
                const SizedBox(width: 8.0),
                // Number of Reviews
                Text('(${widget.product.fields.numReviews} reviews)'),
              ],
            ),
            const SizedBox(height: 16.0),
          
          // Favorite Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleFavoriteToggle,
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
              label: Text(_isFavorite ? "Remove from Favorites" : "Add to Favorites"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFavorite ? Colors.grey[200] : null,
              ),
            ),
            const SizedBox(height: 24.0),
            // Affiliated Stores Section (Assuming you have it implemented)
            const Text(
              'Affiliated Stores',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // Implement affiliated stores here if applicable
            const SizedBox(height: 24.0),
            // Customer Reviews Section
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // List of Reviews
            widget.product.fields.ratings.isEmpty
                ? const Text("No reviews yet.")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.product.fields.ratings.length,
                    itemBuilder: (context, index) {
                      final review = widget.product.fields.ratings[index];
                      return ReviewWidget(review: review);
                    },
                  ),
            const SizedBox(height: 16.0),
            // Add Review Form (if logged in)
            Provider.of<AuthProvider>(context).isAuthenticated
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add a Review',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      DropdownButtonFormField<int>(
                        value: _selectedRating,
                        decoration: const InputDecoration(
                          labelText: 'Rating',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(5, (index) => index + 1)
                            .map((rating) => DropdownMenuItem(
                                  value: rating,
                                  child: Text(
                                      '$rating Star${rating > 1 ? 's' : ''}'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRating = value ?? 5;
                          });
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _reviewController,
                        decoration: const InputDecoration(
                          labelText: 'Your Review',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () => _addReview(context),
                        child: const Text("Submit Review"),
                      ),
                    ],
                  )
                : const Text("Log in to add a review."),
            const SizedBox(height: 24.0),
            // "You May Also Like" Carousel using PageView
            const Text(
              'You May Also Like',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            similarProducts.isEmpty
                ? const Text("No similar products available.")
                : SizedBox(
                    height: 250.0,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: similarProducts.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
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
                                child: Card(
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(12.0)),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://127.0.0.1:8000/static/${similarProduct.fields.image}',
                                          width: double.infinity,
                                          height: 150.0,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.broken_image,
                                            size: 100.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          similarProduct.fields.name,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Page Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(similarProducts.length, (index) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


