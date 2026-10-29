class CategoryModel {
  final int id;
  final String name;
  final String description;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"] ?? 0,
      name: (json["name"] ?? json["title"] ?? "").toString(),
      description: (json["description"] ?? "").toString(),
      image: (json["imageUrl"] ?? json["image"] ?? "").toString(),
    );
  }
}
