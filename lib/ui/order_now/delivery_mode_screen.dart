import 'package:flutter/material.dart';
import 'package:smartbox/ui/client_details/details_client_screen.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/model/box_model.dart';
import '../utils/constants.dart';

class DeliveryModeScreen extends StatefulWidget {
  final Box box;

  const DeliveryModeScreen({Key? key, required this.box}) : super(key: key);

  @override
  State<DeliveryModeScreen> createState() => _DeliveryModeScreenState();
}

class _DeliveryModeScreenState extends State<DeliveryModeScreen> {
  String livraison = "";
  String label = "";
  TextEditingController deliveryController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mode de livraison"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceWidget,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: space),
                      child: Text(
                        "Livraison",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(space),
                      child: Text(
                        "Comment souhaitez-vous envoyer le coffret cadeau?",
                      ),
                    ),
                    RadioListTile(
                        title: const Text("Livraison à domicile"),
                        value: "domicile",
                        groupValue: livraison,
                        onChanged: (value) {
                          setState(() {
                            livraison = value.toString();
                            label = "Adresse de livraison";
                          });
                        }),
                    RadioListTile(
                        title: const Text("Envoyer par mail"),
                        value: "mail",
                        groupValue: livraison,
                        onChanged: (value) {
                          setState(() {
                            livraison = value.toString();
                            label = "Adresse mail";
                          });
                        }),
                    RadioListTile(
                        title: const Text("Envoyer par sms"),
                        value: "sms",
                        groupValue: livraison,
                        onChanged: (value) {
                          setState(() {
                            livraison = value.toString();
                            label = "Numéro de téléphone";
                          });
                        }),
                  ],
                ),
              ),
              spaceWidget,
              (livraison.isNotEmpty)
                  ? Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(space),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Livraison",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            spaceWidget,
                            spaceWidget,
                            TextFormField(
                              controller: deliveryController,
                              keyboardType: TextInputType.text,
                              showCursor: false,
                              readOnly: false,
                              decoration: InputDecoration(
                                hintText: "Où livrer",
                                label: Text(label),
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
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(space),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (widget.box.discount! > 0)
                ? Text(
                    "${widget.box.discount} $priceSymbol",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  )
                : Text(
                    "${widget.box.price} $priceSymbol",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailsClientScreen(
                          box: widget.box,
                          livraison: livraison,
                          deliveyPlace: deliveryController.text,
                        )));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(sbInputRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Text("Suivant", style: TextStyle(color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
