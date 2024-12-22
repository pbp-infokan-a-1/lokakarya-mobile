// To parse this JSON data, do
//
//     final ratings = ratingsFromJson(jsonString);

import 'dart:convert';

List<Rating> ratingsFromJson(String str) =>
    List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

String ratingsToJson(List<Rating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
  final String model;
  final int pk;
  final Fields fields;

  Rating({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
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
  final String user;
  final String product;
  final int rating;
  final String? review;
  final DateTime createdAt;

  Fields({
    required this.user,
    required this.product,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
      user: json["user"],
      product: json["product"],
      rating: json["rating"],
      review: json["review"],
      createdAt: DateTime.parse(json["created_at"]));

  Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "rating": rating,
        "review": review,
        "created_at": createdAt,
      };
}
