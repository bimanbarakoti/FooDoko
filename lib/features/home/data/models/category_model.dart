// lib/features/home/data/models/category_model.dart

class CategoryModel {
  final String id;
  final String title;
  final String? imageUrl; // <-- THIS MATCHES YOUR REPOSITORY

  CategoryModel({
    required this.id,
    required this.title,
    this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'], // <-- MATCH
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl, // <-- MATCH
    };
  }
}
