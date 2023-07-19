import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartbox/ui/profile/profile_screen.blade.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

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
        title: const Text("Plus", style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          spaceWidget,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(space),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.settings, color: Theme.of(context).primaryColor,),
                const SizedBox(width: 10,),
                const Text("Paramètres"),
              ],
            ),
          ),
          spaceWidget,
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(space),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(Icons.person, color: Theme.of(context).primaryColor,),
                  SizedBox(width: 10,),
                  Text("Profil"),
                ],
              ),
            ),
          ),
          spaceWidget,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(space),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.help, color: Theme.of(context).primaryColor,),
                SizedBox(width: 10,),
                Text("Aide"),
              ],
            ),
          ),
          spaceWidget,
          spaceWidget,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Conditions d'utilisation de l'application mobile", style: Theme.of(context).textTheme.bodySmall,),
          ),
          spaceWidget,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Politique deconfidentialité", style: Theme.of(context).textTheme.bodySmall),
          ),
          spaceWidget,
          Container(
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (snapshot.hasData) {
                  PackageInfo? packageInfo = snapshot.data;
                  return Text("Version ${packageInfo?.version}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).primaryColor));
                }
                return const Text("...");
              },
            ),
          )
        ],
      ),
    );
  }
}
