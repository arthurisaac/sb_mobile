import 'box_model.dart';

class Boxes {
  int? id;
  int? section;
  Box? box;
  String? createdAt;
  String? updatedAt;

  Boxes({this.id, this.section, this.box, this.createdAt, this.updatedAt});

  Boxes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    section = json['section'];
    box = json['box'] != null ? Box.fromJson(json['box']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['section'] = section;
    if (box != null) {
      data['box'] = box!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}