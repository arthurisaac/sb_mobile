import 'box_model.dart';

class SubCategoryItemModel {
  int? id;
  int? subCategory;
  Box? box;
  String? createdAt;
  String? updatedAt;

  SubCategoryItemModel({this.id, this.subCategory, this.box, this.createdAt, this.updatedAt});

  SubCategoryItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategory = json['sub_category'];
    box = json['box'] != null ? Box.fromJson(json['box']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_category'] = subCategory;
    if (box != null) {
      data['box'] = box!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}