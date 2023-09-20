import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbox/features/model/settings_model.dart';
import 'package:smartbox/ui/home/home_screen.dart';
import 'package:smartbox/ui/more/more_screen.dart';
import 'package:smartbox/ui/save_box/save_box_presentation_screen.dart';
import 'package:smartbox/ui/saved/saved_box_screen.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  Future saveSupportContact(
      String supportMail, String supportChat, String supportPhone) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("support_mail", supportMail);
    prefs.setString("support_chat", supportChat);
    prefs.setString("support_phone", supportPhone);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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

              saveSupportContact(
                  settingsModel!.supportMail ?? "",
                  settingsModel.supportChat ?? "",
                  settingsModel.supportPhone ?? "");
              return Center(
                child: [
                  HomeScreen(
                    settingsModel: settingsModel,
                  ),
                  const SaveBoxPresentationScreen(),
                  const SavedBoxScreen(),
                  const MoreScreen()
                ].elementAt(_selectedIndex),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
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
              label: 'Vos cadeaux',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Plus',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
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
