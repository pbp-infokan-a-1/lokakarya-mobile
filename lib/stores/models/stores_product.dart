// To parse this JSON data, do
//
//     final productDetailsModels = productDetailsModelsFromJson(jsonString);

import 'dart:convert';

ProductDetailsModels productDetailsModelsFromJson(String str) => ProductDetailsModels.fromJson(json.decode(str));

String productDetailsModelsToJson(ProductDetailsModels data) => json.encode(data.toJson());

class ProductDetailsModels {
    List<Product> products;

    ProductDetailsModels({
        required this.products,
    });

    factory ProductDetailsModels.fromJson(Map<String, dynamic> json) => ProductDetailsModels(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    String id;
    String name;
    String minPrice;
    String maxPrice;

    Product({
        required this.id,
        required this.name,
        required this.minPrice,
        required this.maxPrice,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "min_price": minPrice,
        "max_price": maxPrice,
    };
}
