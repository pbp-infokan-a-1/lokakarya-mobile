// To parse this JSON data, do
//
//     final statusModel = statusModelFromJson(jsonString);

import 'dart:convert';

List<StatusModel> statusModelFromJson(String str) => List<StatusModel>.from(json.decode(str).map((x) => StatusModel.fromJson(x)));

String statusModelToJson(List<StatusModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusModel {
    String model;
    int pk;
    Fields fields;

    StatusModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
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
    int user;
    String title;
    String description;

    Fields({
        required this.user,
        required this.title,
        required this.description,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "description": description,
    };
}
