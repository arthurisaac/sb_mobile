class Images {
  int? id;
  int? box;
  String? image;
  String? createdAt;
  String? updatedAt;

  Images({this.id, this.box, this.image, this.createdAt, this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    box = json['box'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['box'] = box;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}