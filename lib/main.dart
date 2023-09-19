import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:smartbox/utils/firebase_options.dart';


import 'app/app.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/*Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print('Initialized default app $app');
  }
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await initializeDefault();

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("392533a2-1dc2-43ac-9372-23b3d610c2f0");

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  runApp(await initializeApp());
}


Future<void> makeRequest(String token) async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/users'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    // La requête a réussi, vous pouvez accéder aux données dans response.body
    print(response.body);
  } else {
    // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
    print('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  } catch (e) {
    print(e);
  }
}
