import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartbox/ui/auth/check_code_screen.dart';
import 'package:smartbox/ui/utils/api_body_parameters.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';

import '../utils/api_utils.dart';
import '../utils/widgets_utils.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController(text: "");
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
                      "Reinitialisation du mot de passe",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(space),
                      child: Text(
                        "Entez votre adresse mail pour recevoir un code de récupération.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    spaceWidget,
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
                        filled: true,
                        fillColor: Colors.white,
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
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size.fromHeight(12),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: TextButton(
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
                            resetPassword();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          child: const Center(
                            child: Text("Continuer"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future resetPassword() async {
    UiUtils.modalLoading(context, "Chargement en cours");
    final body = {emailKey: emailController.text};
    final response = await http.post(Uri.parse(resetEmailUrl),
        headers: ApiUtils.getHeaders(), body: body);

    if (mounted) {
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200) {
      //print(response.body);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CheckCodeScreen()));
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

      print(jsonResponse);

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
        print(keyResponse);
        print(valueResponse);
        if (mounted) {
          UiUtils.setSnackBar(
              "Erreur $keyResponse",
              "Une erreur s'est produite $valueResponse",
              context,
              false);
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
    emailController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }
}
