// To parse this JSON data, do
//
//     final storesModel = storesModelFromJson(jsonString);

import 'dart:convert';

List<StoresModel> storesModelFromJson(String str) => List<StoresModel>.from(json.decode(str).map((x) => StoresModel.fromJson(x)));

String storesModelToJson(List<StoresModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoresModel {
    int id;
    String nama;
    HariBuka hariBuka;
    String alamat;
    String email;
    String telepon;
    String image;
    String gmapsLink;

    StoresModel({
        required this.id,
        required this.nama,
        required this.hariBuka,
        required this.alamat,
        required this.email,
        required this.telepon,
        required this.image,
        required this.gmapsLink,
    });

    factory StoresModel.fromJson(Map<String, dynamic> json) => StoresModel(
        id: json["id"],
        nama: json["nama"],
        hariBuka: hariBukaValues.map[json["hari_buka"]]!,
        alamat: json["alamat"],
        email: json["email"],
        telepon: json["telepon"],
        image: json["image"],
        gmapsLink: json["gmaps_link"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "hari_buka": hariBukaValues.reverse[hariBuka],
        "alamat": alamat,
        "email": email,
        "telepon": telepon,
        "image": image,
        "gmaps_link": gmapsLink,
    };
}

enum HariBuka {
    SENIN_JUMAT,
    SENIN_MINGGU,
    SENIN_SABTU
}

final hariBukaValues = EnumValues({
    "Senin-Jumat": HariBuka.SENIN_JUMAT,
    "Senin-Minggu": HariBuka.SENIN_MINGGU,
    "Senin-Sabtu": HariBuka.SENIN_SABTU
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
