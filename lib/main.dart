import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'app/app.dart';

void main() async {
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
