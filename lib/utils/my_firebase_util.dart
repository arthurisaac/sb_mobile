import 'package:firebase_messaging/firebase_messaging.dart';

class MyFirebaseUtil {
  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    //saveToken(token!);
  }

  /*saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authorization = prefs.getString("authorization");
    if (authorization != null) {
      var client = http.Client();
      try {
        var url = Uri.parse('${Util().url}v1/users');
        await http.post(url, headers: <String, String>{
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Http-Method-Override": "PUT",
          'Authorization': 'Bearer $authorization)',
        }, body: {
          "fcm": token
        });
      } catch (error) {
        print(error);
      } finally {
        client.close();
      }
    }
  }*/
}