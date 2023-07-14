import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/utils/constants.dart';

import '../../app/routes.dart';
import '../../features/auth/cubits/register_cubiti.dart';
import '../utils/ui_utils.dart';
import '../utils/widgets_utils.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nomController = TextEditingController(text: "");
  TextEditingController prenomController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController passwordConfirmationController =
      TextEditingController(text: "");
  TextEditingController mobileController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(space),
          child: Column(
            children: [
              spaceWidget,
              Text(
                "Inscription",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              spaceWidget,
              spaceWidget,
              TextFormField(
                controller: nomController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: InputDecoration(
                  labelText: "Nom",
                  hintText: "Nom",
                  errorText: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              spaceWidget,
              TextFormField(
                controller: prenomController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: InputDecoration(
                  labelText: "Prenom",
                  hintText: "Prénom",
                  errorText: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              spaceWidget,
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  errorText: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              spaceWidget,
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  hintText: "Mot de passe",
                  errorText: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              spaceWidget,
              TextFormField(
                controller: passwordConfirmationController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: InputDecoration(
                  labelText: "Confirmation mot de passe",
                  hintText: "Mot de passe",
                  errorText: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              spaceWidget,
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                showCursor: false,
                readOnly: false,
                decoration: InputDecoration(
                  labelText: "Téléphone",
                  hintText: "Téléphone",
                  errorText: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              spaceWidget,
              BlocConsumer<SignUpCubit, SignUpState>(
                bloc: context.read<SignUpCubit>(),
                listener: (context, state) async {
                  if (state is SignUpFailure) {
                    UiUtils.setSnackBar(
                        "Inscription ", state.errorMessage, context, false);
                  }
                  if (state is SignUpSuccess) {
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sbInputRadius),
                      ),
                    ),
                    onPressed: () {
                      context.read<SignUpCubit>().signUpUser(
                            nom: nomController.text.trim(),
                            prenom: prenomController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            passwordConfirmation:
                                passwordConfirmationController.text.trim(),
                            mobile: mobileController.text.trim(),
                          );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      child: const Center(child: Text("Continuer")),
                    ),
                    /*child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        border: Border.all(width: 0),
                        borderRadius: BorderRadius.circular(sbInputRadius),
                      ),
                      child: const Text(
                        "Continuer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),*/
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    mobileController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }
}
