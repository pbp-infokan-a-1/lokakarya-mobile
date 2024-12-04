// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
    String model;
    int pk;
    Fields fields;

    Category({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
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
    String name;

    Fields({
        required this.name,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
