import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../features/auth/cubits/register_cubiti.dart';
import '../utils/ui_utils.dart';

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
  TextEditingController passwordConfirmationController = TextEditingController(text: "");
  TextEditingController mobileController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Inscription"),
              TextFormField(
                controller: nomController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: const InputDecoration(
                  labelText: "Nom",
                  hintText: "Nom",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              TextFormField(
                controller: prenomController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: const InputDecoration(
                  labelText: "Prenom",
                  hintText: "Prénom",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: const InputDecoration(
                  labelText: "Mot de passe",
                  hintText: "Mot de passe",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              TextFormField(
                controller: passwordConfirmationController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                decoration: const InputDecoration(
                  labelText: "Mot de passe",
                  hintText: "Mot de passe",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                showCursor: false,
                readOnly: false,
                decoration: const InputDecoration(
                  labelText: "Téléphone",
                  hintText: "Téléphone",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
                onTap: () {},
              ),
              BlocConsumer<SignUpCubit, SignUpState>(
                bloc: context.read<SignUpCubit>(),
                listener: (context, state) async {
                  if (state is SignUpFailure) {
                    UiUtils.setSnackBar("Inscription ", state.errorMessage, context, false);
                  }
                  if (state is SignUpSuccess) {
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  }
                },
                builder: (context, state) {
                  return TextButton(onPressed: () {
                    context.read<SignUpCubit>().signUpUser(
                      nom: nomController.text.trim(),
                      prenom: prenomController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      passwordConfirmation: passwordConfirmationController.text.trim(),
                      mobile: mobileController.text.trim(),
                    );
                  }, child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Text("Inscription"),
                  ));
                },
              )
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
