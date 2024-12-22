import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/models/rating.dart';
import 'package:lokakarya_mobile/product_page/widgets/star_rating.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatelessWidget {
  final Rating review;
  final String productId;
  final String date;
  final Function(Rating) onReviewEdited;
  final Function(int) onReviewDeleted;

  const ReviewWidget({
    Key? key,
    required this.review,
    required this.productId,
    required this.date,
    required this.onReviewEdited,
    required this.onReviewDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUsername = authProvider.username;

    bool isCurrentUser =
        authProvider.isAuthenticated && currentUsername == review.fields.user;

    return Padding(
      padding: const EdgeInsets.all(12.0), // Ensure shadows are not clipped
      child: Container(
        width: 250.0,
        constraints: const BoxConstraints(
          minHeight: 170.0,
        ), // Make the card bigger
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User and Rating
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    review.fields.user.isNotEmpty
                        ? review.fields.user[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  review.fields.user,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    if (index < review.fields.rating) {
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
                if (isCurrentUser)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        _showEditDialog(context, review);
                      } else if (value == 'Delete') {
                        _confirmDelete(context, review);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8.0),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8.0),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              date.substring(0, 10),
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 10.0,
              ),
            ),
            // Review Text with "See More" logic
            LayoutBuilder(
              builder: (context, constraints) {
                final String reviewText = review.fields.review ?? '';
                final bool isOverflowing = reviewText.length > 100;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOverflowing
                          ? '${reviewText.substring(0, 100)}...'
                          : reviewText,
                      style: const TextStyle(fontSize: 14.0),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isOverflowing)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _showFullReviewDialog(context, reviewText);
                          },
                          child: const Text(
                            'See More',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFullReviewDialog(BuildContext context, String reviewText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Full Review'),
          content: SingleChildScrollView(
            child: Text(
              reviewText,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Rating review) {
    final _editController = TextEditingController(text: review.fields.review);
    int _editRating = review.fields.rating;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool _isSubmitting = false; // To manage loading state

            return AlertDialog(
              title: const Text('Edit Review'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Star Rating Widget
                    StarRatingWidget(
                      initialRating: _editRating,
                      onRatingSelected: (rating) {
                        setState(() {
                          _editRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    // Review Text
                    TextField(
                      controller: _editController,
                      decoration: const InputDecoration(
                        labelText: 'Your Review',
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
                          if (_editRating == 0) {
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

                          final reviewText = _editController.text.trim();

                          setState(() {
                            _isSubmitting = true;
                          });

                          try {
                            final response = await http.post(
                              Uri.parse(
                                  'http://127.0.0.1:8000/api/products/$productId/edit_reviews/${review.pk}/'),
                              headers: {
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({
                                'rating': _editRating,
                                'review': reviewText,
                              }),
                            );

                            if (response.statusCode == 200) {
                              final responseBody = jsonDecode(response.body);
                              final updatedReview =
                                  Rating.fromJson(responseBody);
                              onReviewEdited(updatedReview);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Review updated successfully.")),
                              );

                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Failed to edit review: ${jsonDecode(response.body)}")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("An error occurred: $e")),
                            );
                          }

                          setState(() {
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
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Rating review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Review'),
          content: const Text('Are you sure you want to delete this review?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final reviewId = review.pk.toString();

                final request = context.read<CookieRequest>();
                final response = await request.get(
                  'http://127.0.0.1:8000/api/products/$productId/delete_reviews/$reviewId/',
                  // Override method to DELETE
                );

                if (response.containsKey('message')) {
                  // Successfully deleted
                  onReviewDeleted(review.pk);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Review deleted successfully.")),
                  );

                  Navigator.of(context).pop(); // Close the dialog
                } else if (response.containsKey('error')) {
                  // Error occurred
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Failed to delete review: ${response['error']}")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to delete review.")),
                  );
                }
              },
              child: const Text('Delete'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        );
      },
    );
  }
}
