import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/model/box_model.dart';
import '../../features/model/details_client_model.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

import 'package:http/http.dart' as http;

class SaveBoxDetailsScreen extends StatefulWidget {
  final Box box;
  final Order order;

  const SaveBoxDetailsScreen({Key? key, required this.box, required this.order})
      : super(key: key);

  @override
  State<SaveBoxDetailsScreen> createState() => _SaveBoxDetailsScreenState();
}

class _SaveBoxDetailsScreenState extends State<SaveBoxDetailsScreen> {
  late Box box;
  late Order order;

  @override
  void initState() {
    box = widget.box;
    order = widget.order;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du cadeau"),
      ),
      body: Column(
        children: [
          spaceWidget,
          Text(
            "${box.name}",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          spaceWidget,
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(space),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${box.name}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                spaceWidget,
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("${box.maxPerson} personnes"),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    const Text("|"),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.hourglass_bottom,
                          size: 14,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Validité : ${box.validity} mois")
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Qu'est-ce qui est inclus ?",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                box.isInside != null && box.isInside!.isNotEmpty
                    ? Html(
                        data: box.isInside,
                        style: {
                          "body": Style(
                              padding: HtmlPaddings.zero, margin: Margins.zero),
                          "ul": Style(
                              padding: HtmlPaddings.only(left: 15),
                              margin: Margins.zero,
                              listStyleImage: const ListStyleImage(
                                  "${serverUrl}images/list.jpg")),
                          "li": Style(padding: HtmlPaddings.only(left: 5)),
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Que devrais-je savoir ?",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                box.mustKnow!.isNotEmpty
                    ? Html(
                        data: box.mustKnow,
                        style: {
                          "body": Style(
                              padding: HtmlPaddings.zero, margin: Margins.zero),
                          "ul": Style(
                              padding: HtmlPaddings.only(left: 15),
                              margin: Margins.zero,
                              listStyleImage: const ListStyleImage(
                                  "${serverUrl}images/list.png")),
                          "li": Style(padding: HtmlPaddings.only(left: 5)),
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Html(
                  data: box.description,
                  style: {
                    "body":
                        Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                  },
                ),
              ],
            ),
          ),
          spaceWidget,
          Padding(
            padding: const EdgeInsets.all(space),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sbInputRadius),
                ),
              ),
              onPressed: () async {
                saveBoxDetails();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                child: const Center(
                  child: Text("Enregistrer"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  saveBoxDetails() async {
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

    final response = await http.post(
      Uri.parse(confirmedOrderUrl),
      headers: ApiUtils.getHeaders(),
      body: {
        "order_id": widget.order.id.toString()
      },
    );
    if (response.statusCode == 200) {
      // final responseJson = jsonDecode(response.body);

      if (mounted) {
        Navigator.of(context).pop();

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
                      color: Colors.greenAccent,
                      size: 96,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Some text
                    const Text('Enregistré avec succès'),
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MainScreen()));
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }

      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          barrierDismissible: true,
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
                    Text(
                        'Erreur de connexion. Status : ${response.statusCode} ! '),
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
                      child: Text("Fermer"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      return null;
    }
  }
}
