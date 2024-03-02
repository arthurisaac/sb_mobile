import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../app/routes.dart';
import '../utils/constants.dart';

class PleaseLoginScreen extends StatefulWidget {
  const PleaseLoginScreen({Key? key}) : super(key: key);

  @override
  State<PleaseLoginScreen> createState() => _PleaseLoginScreenState();
}

class _PleaseLoginScreenState extends State<PleaseLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  //Colors.white,
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorDark,
                ],
              )
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(space),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                spaceWidget,
                Lottie.asset(
                  'images/animation_login.json',
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                ),
                spaceWidget,
                const Text("Connectez-vous pour bénéficier de toutes les fonctionnalités.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    /*Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginScreen())
                    );*/
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text("Se connecter maintenant", style: TextStyle(color: Theme.of(context).primaryColor),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
