// lib/widgets/review_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokakarya_mobile/models/rating.dart';

class ReviewWidget extends StatelessWidget {
  final Rating review;

  const ReviewWidget({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(review.fields.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Name and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.fields.user,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Rating Stars
            Row(
              children: List.generate(5, (index) {
                if (index < review.fields.rating) {
                  return const Icon(Icons.star,
                      color: Colors.amber, size: 16.0);
                } else {
                  return const Icon(Icons.star_border,
                      color: Colors.amber, size: 16.0);
                }
              }),
            ),
            const SizedBox(height: 8.0),
            // Review Text
            review.fields.review != null && review.fields.review!.isNotEmpty
                ? Text(
                    review.fields.review!,
                    style: const TextStyle(fontSize: 16.0),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
