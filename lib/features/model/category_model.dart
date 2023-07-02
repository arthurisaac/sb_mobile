class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? image;
  String? createdAt;

  CategoryModel(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.createdAt,});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    name = json['name'] ?? "";
    image = json['image'] ?? "";
    createdAt = json['created_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['created_at'] = createdAt;
    return data;
  }

  CategoryModel copyWith({int? id, String? name, String? image,
    String? createdAt,}) {
    return CategoryModel(
      id : id ?? this.id,
      image : image ?? this.image,
      name : name ?? this.name,
      createdAt : createdAt ?? this.createdAt,
    );
  }

}