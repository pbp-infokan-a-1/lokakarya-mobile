// To parse this JSON data, do
//
//     final PostForum = PostForumFromJson(jsonString);

import 'dart:convert';

List<PostForum> postForumFromJson(String str) => List<PostForum>.from(json.decode(str).map((x) => PostForum.fromJson(x)));

String postForumToJson(List<PostForum> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostForum {
    String model;
    String pk;
    Fields fields;

    PostForum({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory PostForum.fromJson(Map<String, dynamic> json) => PostForum(
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

