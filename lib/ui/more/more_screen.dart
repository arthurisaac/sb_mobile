import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartbox/ui/contact_us/contact_us_screen.dart';
import 'package:smartbox/ui/help/help_screen.dart';
import 'package:smartbox/ui/settings/settings_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../app/routes.dart';
import '../../features/auth/cubits/auth_cubit.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Plus",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          spaceWidget,
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen()));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(space),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Paramètres"),
                ],
              ),
            ),
          ),
          spaceWidget,
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HelpScreen()));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(space),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.help,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Aide"),
                ],
              ),
            ),
          ),
          spaceWidget,
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactUsScreen()));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(space),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.contact_support,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Contactez-nous"),
                ],
              ),
            ),
          ),
          spaceWidget,
          context.read<AuthCubit>().state is Authenticated
              ? GestureDetector(
                  onTap: () {
                    context.read<AuthCubit>().signOut();
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(space),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Déconnexion"),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(space),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.login,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Connexion"),
                      ],
                    ),
                  ),
                ),
          spaceWidget,
          spaceWidget,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Conditions d'utilisation de l'application mobile",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          spaceWidget,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("Politique deconfidentialité",
                style: Theme.of(context).textTheme.bodySmall),
          ),
          spaceWidget,
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot.error);
                }
              }
              if (snapshot.hasData) {
                PackageInfo? packageInfo = snapshot.data;
                return Text("Version ${packageInfo?.version}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).primaryColor));
              }
              return const Text("...");
            },
          )
        ],
      ),
    );
  }
}
