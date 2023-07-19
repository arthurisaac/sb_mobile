import 'box_model.dart';

class Favorite {
  int? id;
  Box? box;
  int? user;
  String? createdAt;
  String? updatedAt;

  Favorite({this.id, this.box, this.user, this.createdAt, this.updatedAt});

  Favorite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    box = json['box'] != null ? Box.fromJson(json['box']) : null;
    user = json['user'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (box != null) {
      data['box'] = box!.toJson();
    }
    data['user'] = user;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
