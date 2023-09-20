class SliderModel {
  int? id;
  //String? title;
  String? image;
  String? type;
  int? typeId;
  //Null? description;
  String? createdAt;
  String? updatedAt;

  SliderModel(
      {this.id,
        //this.title,
        this.image,
        this.type,
        this.typeId,
        //this.description,
        this.createdAt,
        this.updatedAt});

  SliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    //title = json['title'];
    image = json['image'];
    type = json['type'];
    typeId = json['type_id'];
    //description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    //data['title'] = this.title;
    data['image'] = image;
    data['type'] = type;
    data['type_id'] = typeId;
    //data['description'] = this.description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}