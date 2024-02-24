import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartbox/ui/save_box/save_box_details_screen.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/model/box_model.dart';
import '../../features/model/details_client_model.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class SaveBoxManuallyScreen extends StatefulWidget {
  const SaveBoxManuallyScreen({Key? key}) : super(key: key);

  @override
  State<SaveBoxManuallyScreen> createState() => _SaveBoxManuallyScreenState();
}

class _SaveBoxManuallyScreenState extends State<SaveBoxManuallyScreen> {
  TextEditingController numeroController = TextEditingController(text: "");
  Box? box;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrer un cadeau"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            const Text("Entrez le numéro du cadeau"),
            spaceWidget,
            spaceWidget,
            TextFormField(
              controller: numeroController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              decoration: InputDecoration(
                labelText: "",
                hintText: "Numéro",
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
            spaceWidget,
            InkWell(
              onTap: () {
                checkNumberCode();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(sbInputRadius),
                ),
                child: Center(child: const Text('Valider', style: TextStyle(color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkNumberCode() async {
    if (mounted) {
      UiUtils.modalLoading(context, "Chargement en cours");
    }

    final response =
        await http.post(Uri.parse(checkNumberUrl), headers: ApiUtils.getHeaders(), body: {
      "number": numeroController.text,
    });

    if (mounted) {
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['order'];

      if (jsonResponse == null) {
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
                        Icons.error,
                        color: Colors.red,
                        size: 96,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Some text
                      const Text('Code invalide ou cadeau indisponible'),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          //if (!mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(sbInputRadius),
                          ),
                          child: const Text(
                            "Fermer",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } else {
        Order order = Order.fromJson(jsonResponse);
        Box box = Box.fromJson(jsonResponse["box"]);
        if (order.orderConfirmation == null) {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SaveBoxDetailsScreen(
                  box: box,
                  order: order,
                ),
              ),
            );
          }
        } else {
          if (mounted) {
            UiUtils.setSnackBar("Attention", "Cette commande a déjà été reservée.", context, false);
          }
        }
      }
    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  }
}
