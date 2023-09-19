import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smartbox/ui/save_box/save_box_screen.dart';
import 'package:smartbox/ui/saved/saved_box_screen.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../helper/please_login_screen.dart';
import '../utils/constants.dart';

class SaveBoxPresentationScreen extends StatefulWidget {
  const SaveBoxPresentationScreen({Key? key}) : super(key: key);

  @override
  State<SaveBoxPresentationScreen> createState() => _SaveBoxPresentationScreenState();
}

class _SaveBoxPresentationScreenState extends State<SaveBoxPresentationScreen> {
  @override
  Widget build(BuildContext context) {
    return context.read<AuthCubit>().state is Authenticated
    ? Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            Lottie.asset(
              'images/animation_scan.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 30,),
            const Text("Enregistrement coffret cadeau", style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            const Text("Vous avez reçu un coffret cadeau? Procéder à l'enregistrement. Pour ce faire retrouvrez le qrcode ou le numéro du cadeau à l'intérieur de votre coffret.", textAlign: TextAlign.center,),
            spaceWidget,
            const Text("Scanner le qrcode ou entrer manuellement le chiffre pour enregistrer pour cadeau", textAlign: TextAlign.center,),
            const SizedBox(height: 20,),
            Expanded(
              flex: 0,
              child: ButtonTheme(
                minWidth: 320.0,
                height: 50.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SaveBoxScreen()));
                  },
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: const Text(
                    'Scanner',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )  : const PleaseLoginScreen();
  }
}
