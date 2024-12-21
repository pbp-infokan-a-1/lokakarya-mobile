// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

List<ProfileModel> profileModelFromJson(String str) => List<ProfileModel>.from(json.decode(str).map((x) => ProfileModel.fromJson(x)));

String profileModelToJson(List<ProfileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileModel {
    String model;
    int pk;
    Fields fields;

    ProfileModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
    String bio;
    String location;
    DateTime birthDate;
    bool private;
    String? profilePicture;

    Fields({
        required this.user,
        required this.bio,
        required this.location,
        required this.birthDate,
        required this.private,
        this.profilePicture,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        bio: json["bio"],
        location: json["location"],
        birthDate: DateTime.parse(json["birth_date"]),
        private: json["private"],
        profilePicture: json["profile_picture"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "bio": bio,
        "location": location,
        "birth_date": "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
        "private": private,
    };
}
