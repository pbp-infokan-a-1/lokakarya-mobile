// To parse this JSON data, do
//
//     final ForumEntry = ForumEntryFromJson(jsonString);

import 'dart:convert';

List<ForumEntry> ForumEntryFromJson(String str) =>
    List<ForumEntry>.from(json.decode(str).map((x) => ForumEntry.fromJson(x)));

String ForumEntryToJson(List<ForumEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
  int user;
  String title;
  DateTime time;
  String content;
  int votes;
  int comments;

  Fields({
    required this.user,
    required this.title,
    required this.time,
    required this.content,
    required this.votes,
    required this.comments,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        time: DateTime.parse(json["time"]),
        content: json["content"],
        votes: json["votes"],
        comments: json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "time":
            "${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}",
        "content": content,
        "votes": votes,
        "comments": comments,
      };
}
