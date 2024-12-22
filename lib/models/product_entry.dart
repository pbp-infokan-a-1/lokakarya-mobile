// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

import 'category.dart';
import 'rating.dart';
import 'store_entry.dart';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(
    json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
  final String model;
  final String pk;
  final Fields fields;

  ProductEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  final String name;
  final Category category;
  final int minPrice;
  final int maxPrice;
  final String description;
  final List<StoreEntry> store;
  final String? image;
  double averageRating;
  int numReviews;
  List<Rating> ratings;

  Fields({
    required this.name,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.description,
    required this.store,
    this.image,
    required this.averageRating,
    required this.numReviews,
    required this.ratings,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        category: Category.fromJson(json["category"]),
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
        description: json["description"],
        store: List<StoreEntry>.from(
            json["store"].map((x) => StoreEntry.fromJson(x))),
        image: json["image"],
        averageRating: (json["average_rating"]).toDouble() ?? 0.0,
        numReviews: json["num_reviews"] ?? 0,
        ratings: json["ratings"] is List
            ? List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "min_price": minPrice,
        "max_price": maxPrice,
        "description": description,
        "store": List<dynamic>.from(store.map((x) => x.toJson())),
        "image": image,
        "average_rating": averageRating,
        "num_reviews": numReviews,
        "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
      };
}
