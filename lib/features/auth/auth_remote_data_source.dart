import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smartbox/ui/utils/strings_constants.dart';

import '../../ui/utils/api_body_parameters.dart';
import '../../ui/utils/api_utils.dart';
import '../../ui/utils/constants.dart';
import 'auth_exception.dart';

class AuthRemoteDataSource {
  Future<dynamic> signInUser({String? email, String? password}) async {
    try {
      String fcmToken = await getFCMToken();
      //body of post request
      final body = {
        emailKey: email,
        passwordKey: password,
        //fcmIdKey: fcmToken
      };
      //print("call here"+body.toString());
      final response = await http.post(Uri.parse(loginUrl),
          body: body, headers: ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);
      //print(responseJson);

      if (responseJson['error'] != null) {
        throw AuthException(errorMessageCode: responseJson['message']);
      }

      return responseJson['user'];
    } on SocketException catch (_) {
      throw AuthException(errorMessageCode: "Aucun accès internet");
    } on AuthException catch (e) {
      throw AuthException(errorMessageCode: e.toString());
    } catch (e) {
      //print(e.toString());
      throw AuthException(errorMessageCode: e.toString());
    }
  }

  Future<dynamic> addUser({
    String? name,
    String? email,
    String? mobile,
    String? password,
    String? passwordConfirmation,
  }) async {
    try {
      //body of post request
      final body = {
        nameKey: name,
        emailKey: email,
        //mobileKey: mobile,
        passwordKey: password,
        passwordConfirmationKey: passwordConfirmation,
        mobileKey: mobile
        //fcmIdKey: fcmToken,
      };
      //print("call here"+body.toString());
      final response = await http.post(Uri.parse(registerUrl),
          body: body, headers: ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);
      //print(responseJson);
      //print(responseJson["user"]);

      if (responseJson.containsKey('error')) {
        throw AuthException(errorMessageCode: responseJson['message']);
      }

      return responseJson['user'];
    } on SocketException catch (_) {
      throw AuthException(errorMessageCode: "Aucun accès internet");
    } on AuthException catch (e) {
      throw AuthException(errorMessageCode: e.toString());
    } catch (e) {
      //print(e.toString());
      throw AuthException(errorMessageCode: e.toString());
    }
  }


  Future<dynamic> updatePassword({
    String? password,
    String? passwordConfirmation,
  }) async {
    try {
      final body = {
        "password": password,
        "password_confirmation": passwordConfirmation,
        //fcmIdKey: fcmToken,
      };
      final response = await http.post(Uri.parse(updatePasswordUrl),
          body: body, headers: ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);

      if (responseJson.containsKey('errors')) {
        throw AuthException(errorMessageCode: responseJson['message']);
      }

      return responseJson['message'];
    } on SocketException catch (_) {
      throw AuthException(errorMessageCode: noInternet);
    } on AuthException catch (e) {
      throw AuthException(errorMessageCode: e.toString());
    } catch (e) {
      throw AuthException(errorMessageCode: e.toString());
    }
  }


  Future<dynamic> updateUser({
    String? nom,
    String? prenom,
    String? telephone,
    String? mobile,
  }) async {
    try {
      final body = {
        "nom": nom,
        "prenom": prenom,
        "telephone": telephone,
        "mobile": telephone,
        //fcmIdKey: fcmToken,
      };
      final response = await http.post(Uri.parse(updateUserUrl),
          body: body, headers: ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);

      if (responseJson.containsKey('errors')) {
        throw AuthException(errorMessageCode: responseJson['message']);
      }

      return responseJson;
    } on SocketException catch (_) {
      throw AuthException(errorMessageCode: noInternet);
    } on AuthException catch (e) {
      throw AuthException(errorMessageCode: e.toString());
    } catch (e) {
      throw AuthException(errorMessageCode: e.toString());
    }
  }


  static Future<String> getFCMToken() async {
    try {
      return await "token"; //fcm.FirebaseMessaging.instance.getToken() ?? "";
    } catch (e) {
      return "";
    }
  }
}
