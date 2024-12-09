// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(
    json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
  Model model;
  Fields fields;

  ProductEntry({
    required this.model,
    required this.fields,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: modelValues.map[json["model"]]!,
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "fields": fields.toJson(),
      };
}

class Fields {
  String name;
  int category;
  int minPrice;
  int maxPrice;
  String description;
  List<int> store;
  String image;

  Fields({
    required this.name,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.description,
    required this.store,
    required this.image,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        category: json["category"],
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
        description: json["description"],
        store: List<int>.from(json["store"].map((x) => x)),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "min_price": minPrice,
        "max_price": maxPrice,
        "description": description,
        "store": List<dynamic>.from(store.map((x) => x)),
        "image": image,
      };
}

enum Model { PRODUCTPAGE_PRODUCT }

final modelValues =
    EnumValues({"productpage.product": Model.PRODUCTPAGE_PRODUCT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}