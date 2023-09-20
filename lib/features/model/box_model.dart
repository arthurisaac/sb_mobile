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
  String? trique;
  Map<String, dynamic>? favorites;
  List<Images>? images;
  String? createdAt;
  String? updatedAt;

  Box({
    this.id,
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
    this.trique,
    this.images,
    this.favorites,
    this.createdAt,
    this.updatedAt,
  });

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
    trique = json['trique'];
    favorites = json['favorites'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['partner'] = partner;
    data['user'] = user;
    data['name'] = name;
    data['notation'] = notation;
    data['notation_count'] = notationCount;
    data['price'] = price;
    data['discount'] = discount;
    data['discount_code'] = discountCode;
    data['min_person'] = minPerson;
    data['max_person'] = maxPerson;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['validity'] = validity;
    data['description'] = description;
    data['must_know'] = mustKnow;
    data['is_inside'] = isInside;
    data['country'] = country;
    data['enable'] = enable;
    data['image'] = image;
    data['favorites'] = favorites;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
