// To parse this JSON data, do
//
//     final storeEntry = storeEntryFromJson(jsonString);

import 'dart:convert';

List<StoreEntry> storeEntryFromJson(String str) => List<StoreEntry>.from(json.decode(str).map((x) => StoreEntry.fromJson(x)));

String storeEntryToJson(List<StoreEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreEntry {
    Model model;
    int pk;
    Fields fields;

    StoreEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory StoreEntry.fromJson(Map<String, dynamic> json) => StoreEntry(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
  String nama;
  HariBuka hariBuka;
  String alamat;
  String email;
  String telepon;
  String? image;
  String gmapsLink;

  Fields({
    required this.nama,
    required this.hariBuka,
    required this.alamat,
    required this.email,
    required this.telepon,
    this.image,
    required this.gmapsLink,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        nama: json["nama"] ?? "Unknown",
        hariBuka: hariBukaValues.map[json["hari_buka"]] ?? HariBuka.SENIN_JUMAT,
        alamat: json["alamat"] ?? "Unknown Address",
        email: json["email"] ?? "Unknown Email",
        telepon: json["telepon"] ?? "Unknown Phone",
        image: json["image"],
        gmapsLink: json["gmaps_link"] ?? "Unknown Link",
      );

  Map<String, dynamic> toJson() => {
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

enum Model {
    STOREPAGE_TOKO
}

final modelValues = EnumValues({
    "storepage.Toko": Model.STOREPAGE_TOKO
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
