import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/utils/constants.dart';

import '../../app/routes.dart';
import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/auth/cubits/register_cubiti.dart';
import '../main/main_screen.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/register_bg.png"),
            fit: BoxFit.cover,
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(space),
              child: Form(
                key: _formKey,
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
                        filled: true,
                        fillColor: Colors.white,
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
                        filled: true,
                        fillColor: Colors.white,
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
                        filled: true,
                        fillColor: Colors.white,
                        errorText: null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(sbInputRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Entrer un email valide!';
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
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        hintText: "Mot de passe",
                        filled: true,
                        fillColor: Colors.white,
                        errorText: null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(sbInputRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entrer un mot de passe valide';
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
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirmation mot de passe",
                        hintText: "Mot de passe",
                        filled: true,
                        fillColor: Colors.white,
                        errorText: null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(sbInputRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Champ requis';
                        }
                        if (value.length < 8) {
                          return "Le mot de passe doit comporter au moins 8 caractères";
                        }
                        if (value != passwordController.text) {
                          return 'Les mots de passse ne correspondent pas';
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
                        filled: true,
                        fillColor: Colors.white,
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
                        if (state is SignUpProgress) {
                          UiUtils.modalLoading(
                              context, 'Inscription en cours...');
                        }
                        if (state is SignUpFailure) {
                          UiUtils.setSnackBar("Inscription ",
                              state.errorMessage, context, false);
                        }
                        if (state is SignUpSuccess) {
                          context
                              .read<AuthCubit>()
                              .updateDetails(authModel: state.authModel);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MainScreen()));
                        }
                      },
                      builder: (context, state) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Colors.white,
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: const Size.fromHeight(12),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignUpCubit>().signUpUser(
                                    nom: nomController.text.trim(),
                                    prenom: prenomController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    passwordConfirmation:
                                        passwordConfirmationController.text
                                            .trim(),
                                    mobile: mobileController.text.trim(),
                                  );
                            }
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
          ),
        ),
      ],
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
