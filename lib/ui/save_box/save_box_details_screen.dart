import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';
import '../../features/model/details_client_model.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class SaveBoxDetailsScreen extends StatefulWidget {
  final Box box;
  final Order order;

  const SaveBoxDetailsScreen({Key? key, required this.box, required this.order}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            spaceWidget,
            Text(
              "${box.name}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                          const Icon(
                            Icons.people,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("${box.maxPerson} personnes"),
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("|"),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.hourglass_bottom,
                            size: 14,
                          ),
                          const SizedBox(
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
                            "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                            "ul": Style(
                                padding: HtmlPaddings.only(left: 15),
                                margin: Margins.zero,
                                listStyleImage:
                                    const ListStyleImage("${serverUrl}images/list.jpg")),
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
                            "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                            "ul": Style(
                                padding: HtmlPaddings.only(left: 15),
                                margin: Margins.zero,
                                listStyleImage:
                                    const ListStyleImage("${serverUrl}images/list.png")),
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
                      "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                    },
                  ),
                ],
              ),
            ),
            spaceWidget,
            Padding(
              padding: const EdgeInsets.all(space),
              child: InkWell(
                onTap: () async {
                  saveBoxDetails();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                  child: const Center(
                    child: Text("Enregistrer", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  saveBoxDetails() async {
    UiUtils.modalLoading(context, "Enregistrement en cours...");

    final response = await http.post(
      Uri.parse(confirmedOrderUrl),
      headers: ApiUtils.getHeaders(),
      body: {
        "order_id": widget.order.id.toString(),
        "user": context.read<AuthCubit>().getId().toString(),
      },
    );
    if (response.statusCode == 200) {
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
                    Lottie.asset(
                      'images/animation_success.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                      repeat: false,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Some text
                    const Text('Enregistré avec succès', style: TextStyle(fontWeight: FontWeight.w600),),
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
                        /*ReservationScreen(
                          box: widget.box,
                        )*/
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      child: const Text("OK! Retour à l'acceuil"),
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
                    Text('Erreur de connexion. Status : ${response.statusCode} ! '),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Text("Fermer", style: TextStyle(color: Colors.white)),
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

      return null;
    }
  }
}
