class Favorite {
  final String id;

  Favorite({required this.id});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
