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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_category'] = this.subCategory;
    if (this.box != null) {
      data['box'] = this.box!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}