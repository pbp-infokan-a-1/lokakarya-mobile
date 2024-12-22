// To parse this JSON data, do
//
//     final forumEntry = forumEntryFromJson(jsonString);

import 'dart:convert';

List<ForumEntry> forumEntryFromJson(String str) => List<ForumEntry>.from(json.decode(str).map((x) => ForumEntry.fromJson(x)));

String forumEntryToJson(List<ForumEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumEntry {
    String model;
    String pk;
    Fields fields;

    ForumEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ForumEntry.fromJson(Map<String, dynamic> json) => ForumEntry(
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
    String title;
    String content;
    int author;
    DateTime createdAt;
    int totalUpvotes;
    List<int> upvotes;

    Fields({
        required this.title,
        required this.content,
        required this.author,
        required this.createdAt,
        required this.totalUpvotes,
        required this.upvotes,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        content: json["content"],
        author: json["author"],
        createdAt: DateTime.parse(json["created_at"]),
        totalUpvotes: json["total_upvotes"],
        upvotes: List<int>.from(json["upvotes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "author": author,
        "created_at": createdAt.toIso8601String(),
        "total_upvotes": totalUpvotes,
        "upvotes": List<dynamic>.from(upvotes.map((x) => x)),
    };
}

