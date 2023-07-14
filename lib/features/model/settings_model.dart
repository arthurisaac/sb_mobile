class SettingsModel {
  int? id;
  int? bannerAdEnable;
  String? bannerAd;
  String? headerBackground;
  String? headerTitle;
  int? headerCategoory;
  int? headerHideButton;
  int? maintenanceMode;
  String? minVersion;
  String? createdAt;
  String? updatedAt;

  SettingsModel(
      {this.id,
        this.bannerAdEnable,
        this.bannerAd,
        this.headerBackground,
        this.headerTitle,
        this.headerCategoory,
        this.headerHideButton,
        this.maintenanceMode,
        this.minVersion,
        this.createdAt,
        this.updatedAt});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerAdEnable = json['banner_ad_enable'];
    bannerAd = json['banner_ad'];
    headerBackground = json['header_background'];
    headerTitle = json['header_title'];
    headerCategoory = json['header_categoory'];
    headerHideButton = json['header_hide_button'];
    maintenanceMode = json['maintenance_mode'];
    minVersion = json['min_version'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner_ad_enable'] = this.bannerAdEnable;
    data['banner_ad'] = this.bannerAd;
    data['header_background'] = this.headerBackground;
    data['header_title'] = this.headerTitle;
    data['header_categoory'] = this.headerCategoory;
    data['header_hide_button'] = this.headerHideButton;
    data['maintenance_mode'] = this.maintenanceMode;
    data['min_version'] = this.minVersion;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}