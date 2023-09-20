class SettingsModel {
  int? id;
  int? bannerAdEnable;
  String? bannerAd;
  String? bannerAdDetail;
  String? headerBackground;
  String? headerTitle;
  int? headerCategoory;
  int? headerHideButton;
  int? maintenanceMode;
  String? minVersion;
  String? supportPhone;
  String? supportMail;
  String? supportChat;
  String? createdAt;
  String? updatedAt;

  SettingsModel(
      {this.id,
        this.bannerAdEnable,
        this.bannerAd,
        this.bannerAdDetail,
        this.headerBackground,
        this.headerTitle,
        this.headerCategoory,
        this.headerHideButton,
        this.maintenanceMode,
        this.minVersion,
        this.supportPhone,
        this.supportMail,
        this.supportChat,
        this.createdAt,
        this.updatedAt});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerAdEnable = json['banner_ad_enable'];
    bannerAd = json['banner_ad'];
    bannerAdDetail = json['banner_ad_detail'];
    headerBackground = json['header_background'];
    headerTitle = json['header_title'];
    headerCategoory = json['header_categoory'];
    headerHideButton = json['header_hide_button'];
    maintenanceMode = json['maintenance_mode'];
    minVersion = json['min_version'];
    supportPhone = json['support_phone'];
    supportMail = json['support_mail'];
    supportChat = json['support_chat'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['banner_ad_enable'] = bannerAdEnable;
    data['banner_ad'] = bannerAd;
    data['header_background'] = headerBackground;
    data['header_title'] = headerTitle;
    data['header_categoory'] = headerCategoory;
    data['header_hide_button'] = headerHideButton;
    data['maintenance_mode'] = maintenanceMode;
    data['min_version'] = minVersion;
    data['suport_phone'] = supportPhone;
    data['support_mail'] = supportMail;
    data['support_chat'] = supportChat;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}