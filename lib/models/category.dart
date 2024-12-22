class Category {
  final String model;
  final int pk;
  final CategoryFields fields;

  Category({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        model: json["model"],
        pk: json["pk"],
        fields: CategoryFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && pk == other.pk;

  @override
  int get hashCode => pk.hashCode;
}

class CategoryFields {
  final String name;

  CategoryFields({
    required this.name,
  });

  factory CategoryFields.fromJson(Map<String, dynamic> json) => CategoryFields(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
