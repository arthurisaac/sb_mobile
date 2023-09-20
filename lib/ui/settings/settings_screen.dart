import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbox/ui/main/onboarding_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../profile/profile_screen.blade.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool notification = false;

  Future<void> getNotification() async {
    final SharedPreferences prefs = await _prefs;
    bool notification = prefs.getBool('notification') ?? false;

    setState(() {
      notification = notification;
    });
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body: Column(
        children: [
          spaceWidget,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(space),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Activer / Désactiver les notifications"),
                    const SizedBox(
                      width: 10,
                    ),
                    Switch(
                      onChanged: (value) async {
                        setState(() {
                          notification = value;
                        });

                        final SharedPreferences prefs = await _prefs;
                        prefs.setBool("notification", notification);

                        OneSignal.shared.disablePush(notification);
                      },
                      value: notification,
                    )
                  ],
                )
              ],
            ),
          ),
          spaceWidget,
          context.read<AuthCubit>().state is Authenticated
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(space),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Gérer votre compte"),
                      ],
                    ),
                  ),
                )
              : Container(),
          spaceWidget,
          context.read<AuthCubit>().state is Authenticated
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: space, horizontal: space),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.no_accounts,
                                    size: 50,
                                  ),
                                  spaceWidget,
                                  const Text(
                                    "Supprimer le comte",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  spaceWidget,
                                  const Text(
                                    "êtes-vous sûr(e) de vouloir supprimer le compte GIFT?",
                                    textAlign: TextAlign.center,
                                  ),
                                  spaceWidget,
                                  const Text(
                                    "Cette acction ne peut être annulée",
                                    textAlign: TextAlign.center,
                                  ),
                                  spaceWidget,
                                  const Text(
                                    "La suppression du compte entrainera la perte de tous les bons et coffrets cadeaux enregistrés et de tous autre compte GIFT lié à votre adresse e-mail. Si vous avez une à support@gift.com",
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(
                                              sbInputRadius)),
                                      child: const Text(
                                        "Non, je veux le garder",
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  spaceWidget,
                                  GestureDetector(
                                    onTap: () {
                                      delUser();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Oui, supprimer le compte",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(space),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.no_accounts_sharp,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Suppression de votre compte"),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  delUser() async {
    UiUtils.modalLoading(context, "Suppression en cours");

    final body = {userKey: context.read<AuthCubit>().getId().toString()};
    final response = await post(Uri.parse(deleteUserUrl),
        headers: ApiUtils.getHeaders(), body: body);

    if (mounted) Navigator.of(context).pop();

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (!mounted) return;

      UiUtils.okAlertDialog(
          context, "Succès", "Votre compte a été supprimé avec succès", () {
        context.read<AuthCubit>().signOut();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      });
    }
  }
}
