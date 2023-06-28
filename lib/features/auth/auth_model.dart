class AuthModel {
  int? id;
  String? ipAddress;
  String? nom;
  String? prenom;
  String? email;
  String? mobile;
  String? image;
  String? countryCode;
  String? city;
  String? country;
  String? fcmId;
  String? latitude;
  String? longitude;
  String? createdAt;

  AuthModel(
      {this.id,
        this.ipAddress,
        this.nom,
        this.prenom,
        this.email,
        this.mobile,
        this.image,
        this.countryCode,
        this.city,
        this.country,
        this.fcmId,
        this.latitude,
        this.longitude,
        this.createdAt,});

  AuthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    ipAddress = json['ip_address'] ?? "";
    nom = json['nom'] ?? "";
    prenom = json['prenom'] ?? "";
    email = json['email'] ?? "";
    mobile = json['mobile'] ?? "";
    image = json['image'] ?? "";
    countryCode = json['country_code'] ?? "";
    city = json['city'] ?? "";
    fcmId = json['fcm_id'] ?? "";
    latitude = json['latitude'] ?? "";
    longitude = json['longitude'] ?? "";
    createdAt = json['created_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ip_address'] = ipAddress;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['email'] = email;
    data['mobile'] = mobile;
    data['image'] = image;
    data['country_code'] = countryCode;
    data['city'] = city;
    data['fcm_id'] = fcmId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    return data;
  }

  AuthModel copyWith({int? id, String? ipAddress, String? name, String? email,
    String? mobile, String? image, String? countryCode, String? city, String? country, String? fcmId,
    String? latitude, String? longitude, String? createdAt,}) {
    return AuthModel(
      id : id ?? this.id,
      ipAddress : ipAddress ?? this.ipAddress,
      nom : nom ?? this.nom,
      prenom : prenom ?? this.prenom,
      email : email ?? this.email,
      mobile : mobile ?? this.mobile,
      image : image ?? this.image,
      countryCode : countryCode ?? this.countryCode,
      city : city ?? this.city,
      fcmId : fcmId ?? this.fcmId,
      latitude : latitude ?? this.latitude,
      longitude : longitude ?? this.longitude,
      createdAt : createdAt ?? this.createdAt,
    );
  }

}