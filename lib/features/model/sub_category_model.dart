import 'package:smartbox/features/model/sub_category_item_model.dart';

class Subcategory {
  int? id;
  int? category;
  String? title;
  String? description;
  String? image;
  //String? createdAt;
  //String? updatedAt;
  List<SubCategoryItemModel>? items;

  Subcategory(
      {this.id,
        this.category,
        this.title,
        this.description,
        this.image,
        //this.createdAt,
        //this.updatedAt
      });

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    //createdAt = json['created_at'];
    //updatedAt = json['updated_at'];
    if (json['items'] != null) {
      items = <SubCategoryItemModel>[];
      json['items'].forEach((v) {
        items!.add(SubCategoryItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    //data['created_at'] = createdAt;
    //data['updated_at'] = updatedAt;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}