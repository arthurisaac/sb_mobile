class AuthModel {
  int? id;
  String? ipAddress;
  String? username;
  String? email;
  String? mobile;
  String? image;
  String? balance;
  String? rating;
  String? noOfRatings;
  String? activationSelector;
  String? activationCode;
  String? forgottenPasswordSelector;
  String? forgottenPasswordCode;
  String? forgottenPasswordTime;
  String? rememberSelector;
  String? rememberCode;
  String? createdOn;
  String? lastLogin;
  String? active;
  String? company;
  String? address;
  String? bonus;
  String? dob;
  String? countryCode;
  String? city;
  String? area;
  String? street;
  String? pincode;
  String? serviceableCity;
  String? apikey;
  String? referralCode;
  String? friendsCode;
  String? fcmId;
  String? latitude;
  String? longitude;
  String? createdAt;

  AuthModel(
      {this.id,
        this.ipAddress,
        this.username,
        this.email,
        this.mobile,
        this.image,
        this.balance,
        this.rating,
        this.noOfRatings,
        this.activationSelector,
        this.activationCode,
        this.forgottenPasswordSelector,
        this.forgottenPasswordCode,
        this.forgottenPasswordTime,
        this.rememberSelector,
        this.rememberCode,
        this.createdOn,
        this.lastLogin,
        this.active,
        this.company,
        this.address,
        this.bonus,
        this.dob,
        this.countryCode,
        this.city,
        this.area,
        this.street,
        this.pincode,
        this.serviceableCity,
        this.apikey,
        this.referralCode,
        this.friendsCode,
        this.fcmId,
        this.latitude,
        this.longitude,
        this.createdAt,});

  AuthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    ipAddress = json['ip_address'] ?? "";
    username = json['username'] ?? "";
    email = json['email'] ?? "";
    mobile = json['mobile'] ?? "";
    image = json['image'] ?? "";
    balance = json['balance'] ?? "";
    rating = json['rating'] ?? "";
    noOfRatings = json['no_of_ratings'] ?? "";
    activationSelector = json['activation_selector'] ?? "";
    activationCode = json['activation_code'] ?? "";
    forgottenPasswordSelector = json['forgotten_password_selector'] ?? "";
    forgottenPasswordCode = json['forgotten_password_code'] ?? "";
    forgottenPasswordTime = json['forgotten_password_time'] ?? "";
    rememberSelector = json['remember_selector'] ?? "";
    rememberCode = json['remember_code'] ?? "";
    createdOn = json['created_on'] ?? "";
    lastLogin = json['last_login'] ?? "";
    active = json['active'] ?? "";
    company = json['company'] ?? "";
    address = json['address'] ?? "";
    bonus = json['bonus'] ?? "";
    dob = json['dob'] ?? "";
    countryCode = json['country_code'] ?? "";
    city = json['city'] ?? "";
    area = json['area'] ?? "";
    street = json['street'] ?? "";
    pincode = json['pincode'] ?? "";
    serviceableCity = json['serviceable_city'] ?? "";
    apikey = json['apikey'] ?? "";
    referralCode = json['referral_code'] ?? "";
    friendsCode = json['friends_code'] ?? "";
    fcmId = json['fcm_id'] ?? "";
    latitude = json['latitude'] ?? "";
    longitude = json['longitude'] ?? "";
    createdAt = json['created_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ip_address'] = ipAddress;
    data['username'] = username;
    data['email'] = email;
    data['mobile'] = mobile;
    data['image'] = image;
    data['balance'] = balance;
    data['rating'] = rating;
    data['no_of_ratings'] = noOfRatings;
    data['activation_selector'] = activationSelector;
    data['activation_code'] = activationCode;
    data['forgotten_password_selector'] = forgottenPasswordSelector;
    data['forgotten_password_code'] = forgottenPasswordCode;
    data['forgotten_password_time'] = forgottenPasswordTime;
    data['remember_selector'] = rememberSelector;
    data['remember_code'] = rememberCode;
    data['created_on'] = createdOn;
    data['last_login'] = lastLogin;
    data['active'] = active;
    data['company'] = company;
    data['address'] = address;
    data['bonus'] = bonus;
    data['dob'] = dob;
    data['country_code'] = countryCode;
    data['city'] = city;
    data['area'] = area;
    data['street'] = street;
    data['pincode'] = pincode;
    data['serviceable_city'] = serviceableCity;
    data['apikey'] = apikey;
    data['referral_code'] = referralCode;
    data['friends_code'] = friendsCode;
    data['fcm_id'] = fcmId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    return data;
  }

  AuthModel copyWith({int? id, String? ipAddress, String? name, String? email,
    String? mobile, String? image, String? balance, String? rating, String? noOfRatings, String? activationSelector, String? activationCode,
    String? forgottenPasswordSelector, String? forgottenPasswordCode, String? forgottenPasswordTime, String? rememberSelector,
    String? rememberCode, String? createdOn, String? lastLogin, String? active, String? company, String? address,
    String? bonus, String? dob, String? countryCode, String? city, String? area, String? street,
    String? pincode, String? serviceableCity, String? apikey, String? referralCode, String? friendsCode, String? fcmId,
    String? latitude, String? longitude, String? createdAt,}) {
    return AuthModel(
      id : id ?? this.id,
      ipAddress : ipAddress ?? this.ipAddress,
      username : name ?? username,
      email : email ?? this.email,
      mobile : mobile ?? this.mobile,
      image : image ?? this.image,
      balance : balance ?? this.balance,
      rating : rating ?? this.rating,
      noOfRatings : noOfRatings ?? this.noOfRatings,
      activationSelector : activationSelector ?? this.activationSelector,
      activationCode : activationCode ?? this.activationCode,
      forgottenPasswordSelector : forgottenPasswordSelector ?? this.forgottenPasswordSelector,
      forgottenPasswordCode : forgottenPasswordCode ?? this.forgottenPasswordCode,
      forgottenPasswordTime : forgottenPasswordTime ?? this.forgottenPasswordTime,
      rememberSelector : rememberSelector ?? this.rememberSelector,
      rememberCode : rememberCode ?? this.rememberCode,
      createdOn : createdOn ?? this.createdOn,
      lastLogin : lastLogin ?? this.lastLogin,
      active : active ?? this.active,
      company : company ?? this.company,
      address : address ?? this.address,
      bonus : bonus ?? this.bonus,
      dob : dob ?? this.dob,
      countryCode : countryCode ?? this.countryCode,
      city : city ?? this.city,
      area : area ?? this.area,
      street : street ?? this.street,
      pincode : pincode ?? this.pincode,
      serviceableCity : serviceableCity ?? this.serviceableCity,
      apikey : apikey ?? this.apikey,
      referralCode : referralCode ?? this.referralCode,
      friendsCode : friendsCode ?? this.friendsCode,
      fcmId : fcmId ?? this.fcmId,
      latitude : latitude ?? this.latitude,
      longitude : longitude ?? this.longitude,
      createdAt : createdAt ?? this.createdAt,
    );
  }

}