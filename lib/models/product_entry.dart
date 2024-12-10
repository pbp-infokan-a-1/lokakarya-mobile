// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    Model model;
    String pk;
    Fields fields;

    ProductEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
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
    String name;
    int category;
    Image image;
    String minPrice;
    String maxPrice;
    String description;
    List<int> store;

    Fields({
        required this.name,
        required this.category,
        required this.image,
        required this.minPrice,
        required this.maxPrice,
        required this.description,
        required this.store,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        category: json["category"],
        image: imageValues.map[json["image"]]!,
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
        description: json["description"],
        store: List<int>.from(json["store"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "image": imageValues.reverse[image],
        "min_price": minPrice,
        "max_price": maxPrice,
        "description": description,
        "store": List<dynamic>.from(store.map((x) => x)),
    };
}

enum Image {
    AVATARS_DEFAULTS_JPEG
}

final imageValues = EnumValues({
    "/avatars/defaults.jpeg": Image.AVATARS_DEFAULTS_JPEG
});

enum Model {
    PRODUCTPAGE_PRODUCT
}

final modelValues = EnumValues({
    "productpage.product": Model.PRODUCTPAGE_PRODUCT
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
