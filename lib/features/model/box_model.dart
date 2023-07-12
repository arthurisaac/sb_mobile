import 'images_model.dart';

class Box {
  int? id;
  int? category;
  int? partner;
  int? user;
  String? name;
  int? notation;
  int? notationCount;
  int? price;
  int? discount;
  String? discountCode;
  int? minPerson;
  int? maxPerson;
  String? startTime;
  String? endTime;
  int? validity;
  String? description;
  String? mustKnow;
  String? isInside;
  String? country;
  int? enable;
  String? image;
  List<Images>? images;
  String? createdAt;
  String? updatedAt;

  Box(
      {this.id,
        this.category,
        this.partner,
        this.user,
        this.name,
        this.notation,
        this.notationCount,
        this.price,
        this.discount,
        this.discountCode,
        this.minPerson,
        this.maxPerson,
        this.startTime,
        this.endTime,
        this.validity,
        this.description,
        this.mustKnow,
        this.isInside,
        this.country,
        this.enable,
        this.image,
        this.images,
        this.createdAt,
        this.updatedAt});

  Box.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    partner = json['partner'];
    user = json['user'];
    name = json['name'];
    notation = json['notation'];
    notationCount = json['notation_count'];
    price = json['price'];
    discount = json['discount'];
    discountCode = json['discount_code'];
    minPerson = json['min_person'];
    maxPerson = json['max_person'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    validity = json['validity'];
    description = json['description'];
    mustKnow = json['must_know'];
    isInside = json['is_inside'];
    country = json['country'];
    enable = json['enable'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['partner'] = this.partner;
    data['user'] = this.user;
    data['name'] = this.name;
    data['notation'] = this.notation;
    data['notation_count'] = this.notationCount;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['discount_code'] = this.discountCode;
    data['min_person'] = this.minPerson;
    data['max_person'] = this.maxPerson;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['validity'] = this.validity;
    data['description'] = this.description;
    data['must_know'] = this.mustKnow;
    data['is_inside'] = this.isInside;
    data['country'] = this.country;
    data['enable'] = this.enable;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
