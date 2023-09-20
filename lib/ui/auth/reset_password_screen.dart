import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartbox/ui/auth/login_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';

import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/ui_utils.dart';
import '../utils/widgets_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String code;
  const ResetPasswordScreen({Key? key, required this.code}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController passwordConfirmationController =
      TextEditingController(text: "");
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
                      "Nouveau mot de passe",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    spaceWidget,
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
                    spaceWidget,
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size.fromHeight(12),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          passwordReset();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        child: const Center(child: Text("Continuer")),
                      ),
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

  Future passwordReset() async {
    UiUtils.modalLoading(context, "Chargement en cours");
    final body = {
      codeKey: widget.code,
      passwordKey: passwordController.text,
      passwordConfirmationKey: passwordConfirmationController.text
    };
    final response = await http.post(Uri.parse(passwordResetUrl),
        headers: ApiUtils.getHeaders(), body: body);

    if (mounted) {
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200) {
      if (mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The loading indicator
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.lightGreenAccent,
                      size: 96,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Some text
                    const Text("Mot de passe modifié avec succès"),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sbInputRadius),
                        ),
                      ),
                      onPressed: () {
                        //if (!mounted) return;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Fermer"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else if (response.statusCode == 404) {
      if (mounted) {
        UiUtils.setSnackBar(
            "Erreur",
            "Une erreur ${response.statusCode} s'est produite.",
            context,
            false);
      }
    } else if (response.statusCode == 422) {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }

      final responseJson = jsonDecode(response.body);
      var jsonResponse = responseJson['errors'];

      //print(jsonResponse);

      var keyResponse = "";
      var valueResponse = "";

      jsonResponse.keys.forEach((key) {
        keyResponse = key;
      });
      if (jsonResponse.values.length > 0) {
        if (jsonResponse[keyResponse].length > 0) {
          valueResponse = jsonResponse[keyResponse][0];
        }
      }

      if (keyResponse.isNotEmpty && valueResponse.isNotEmpty) {
        if (mounted) {
          UiUtils.setSnackBar("Erreur $keyResponse",
              "Une erreur s'est produite $valueResponse", context, false);
        }
      }
    } else {
      if (mounted) {
        UiUtils.setSnackBar(
            "Erreur", "Une erreur s'est produite", context, false);
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }
}
