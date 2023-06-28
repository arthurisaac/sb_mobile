import 'package:hive/hive.dart';

import '../../ui/utils/api_body_parameters.dart';
import '../../ui/utils/constants.dart';

class AuthLocalDataSource {
  bool? checkIsAuth() {
    return Hive.box(authBox).get(isLoginKey, defaultValue: false);
  }

  int? getId() {
    return Hive.box(authBox).get(idKey, defaultValue: null);
  }

  String? getName() {
    return Hive.box(authBox).get(nameKey, defaultValue: "");
  }

  String? getNom() {
    return Hive.box(authBox).get(nomKey, defaultValue: "");
  }

  String? getPrenom() {
    return Hive.box(authBox).get(prenomKey, defaultValue: "");
  }

  String? getEmail() {
    return Hive.box(authBox).get(emailKey, defaultValue: "");
  }

  String? getMobile() {
    return Hive.box(authBox).get(mobileKey, defaultValue: "");
  }

  String? getCountry() {
    return Hive.box(authBox).get(countryKey, defaultValue: "");
  }

  String? getCountryCode() {
    return Hive.box(authBox).get(countryCodeKey, defaultValue: "");
  }

  Future<void> setId(int? id) async {
    Hive.box(authBox).put(idKey, id);
  }

  Future<void> setName(String?  name) async {
    Hive.box(authBox).put(nameKey, name);
  }

  Future<void> setNom(String?  nom) async {
    Hive.box(authBox).put(nomKey, nom);
  }

  Future<void> setPrenom(String?  prenom) async {
    Hive.box(authBox).put(prenomKey, prenom);
  }

  Future<void> setIpAddress(String?  ipAddress) async {
    Hive.box(authBox).put(ipAddressKey, ipAddress);
  }

  Future<void> setEmail(String? email) async {
    Hive.box(authBox).put(emailKey, email);
  }

  Future<void> setMobile(String? mobile) async {
    Hive.box(authBox).put(mobileKey, mobile);
  }

  Future<void> setImage(String? image) async {
    Hive.box(authBox).put(imageKey, image);
  }

  Future<void> setCountry(String? ville) async {
    Hive.box(authBox).put(countryKey, ville);
  }

  Future<void> setCountryCode(String? ville) async {
    Hive.box(authBox).put(countryCodeKey, ville);
  }

  Future<void> changeAuthStatus(bool? authStatus) async {
    Hive.box(authBox).put(isLoginKey, authStatus);
  }
}