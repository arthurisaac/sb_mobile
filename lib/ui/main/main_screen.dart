import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartbox/features/model/settings_model.dart';
import 'package:smartbox/ui/home/home_screen.dart';
import 'package:smartbox/ui/profile/profile_screen.blade.dart';
import 'package:smartbox/ui/save_box/save_box_screen.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SettingsModel?>(
        future: getSettings(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Une erreur s'est produite"),
            );
          }
          if (snapshot.hasData) {
            SettingsModel? settingsModel = snapshot.data;
            return Center(
              child: [
                HomeScreen(
                  settingsModel: settingsModel!,
                ),
                const SaveBoxScreen(),
                const Icon(Icons.abc_outlined),
                const ProfileScreen()
              ].elementAt(_selectedIndex),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Enregistrer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Enregistrer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print("Erreur $e");
    }
  }

  Future<SettingsModel?> getSettings() async {
    final response = await http.post(
      Uri.parse(settingsUrl),
      headers: ApiUtils.getHeaders(),
    );
    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez accéder aux données dans response.body
      // print(response.body);
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['settings'];

      SettingsModel settingsModel = SettingsModel.fromJson(jsonResponse);
      return settingsModel;
    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  }
}
