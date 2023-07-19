import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:smartbox/ui/auth/reset_password_screen.dart';

import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';
import '../utils/widgets_utils.dart';
import 'package:http/http.dart' as http;

class CheckCodeScreen extends StatefulWidget {
  const CheckCodeScreen({Key? key}) : super(key: key);

  @override
  State<CheckCodeScreen> createState() => _CheckCodeScreenState();
}

class _CheckCodeScreenState extends State<CheckCodeScreen> {
  //TextEditingController codeController = TextEditingController(text: "");
  OtpFieldController otpController = OtpFieldController();
  final _formKey = GlobalKey<FormState>();
  String code = "";

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
                      "Vérification de code",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(space),
                      child: Text(
                        "Entez le code reçu dans votre boite de reception.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    spaceWidget,
                    spaceWidget,
                    OTPTextField(
                      controller: otpController,
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 45,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 15,
                      style: const TextStyle(fontSize: 17),
                      onCompleted: (pin) {
                        setState(() {
                          code:
                          pin;
                        });
                        checkCode(pin);
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
                            checkCode(code);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          child: const Center(
                            child: Text("Verifier"),
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

  Future checkCode(String code) async {
    UiUtils.modalLoading(context, "Chargement en cours");
    final body = {codeKey: code};
    final response = await http.post(Uri.parse(checkCodeUrl),
        headers: ApiUtils.getHeaders(), body: body);

    if (mounted) {
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200) {
      //print(response.body);
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(code: code)));
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }
}
