import 'boxes_model.dart';

class Section {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;
  List<Boxes>? boxes;

  Section({this.id, this.title, this.createdAt, this.updatedAt, this.boxes});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['boxes'] != null) {
      boxes = <Boxes>[];
      json['boxes'].forEach((v) {
        boxes!.add(Boxes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (boxes != null) {
      data['boxes'] = boxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}