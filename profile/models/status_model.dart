class StatusModel {
  final int id; // Unique identifier for the status
  final Fields fields;

  StatusModel({required this.id, required this.fields});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'], // Ensure this line correctly parses the id from the JSON
      fields: Fields.fromJson(json['fields']),
    );
  }
}

class Fields {
  final String title;
  final String description;

  Fields({required this.title, required this.description});

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
      title: json['title'],
      description: json['description'],
    );
  }
} 