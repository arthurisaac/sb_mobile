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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                minimumSize: const Size.fromHeight(50), // NE
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sbInputRadius),
                ), // W
              ),
              onPressed: () {
                checkNumberCode();
              },
              child: const Text(
                'Valider',
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkNumberCode() async {
    if (mounted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Chargement en cours...')
                ],
              ),
            ),
          );
        },
      );
    }

    final response = await http
        .post(Uri.parse(checkNumberUrl), headers: ApiUtils.getHeaders(), body: {
      "number": numeroController.text,
    });

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
                      Text('Code invalide ou cadeau indisponible'),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(sbInputRadius),
                          ),
                        ),
                        onPressed: () {
                          //if (!mounted) return;
                          Navigator.of(context).pop();
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
      } else {
        Order order = Order.fromJson(jsonResponse);
        Box box = Box.fromJson(jsonResponse["box"]);
        if (order.orderConfirmation == null) {
          if (mounted) {
            Navigator.of(context).pop();
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
            Navigator.of(context).pop();
            UiUtils.setSnackBar(
                "Attention", "Cette commande a déjà été reservée.", context,
                false);
          }
        }
      }
      print(jsonResponse);
    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  }
}
