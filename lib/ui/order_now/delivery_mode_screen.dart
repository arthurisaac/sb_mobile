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
  TextEditingController deliveryController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mode de livraison"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: Column(
          children: [
            RadioListTile(
                title: Text("Livraison à domicile"),
                value: "domicile",
                groupValue: livraison,
                onChanged: (value) {
                  setState(() {
                    livraison = value.toString();
                  });
                }),
            RadioListTile(
                title: Text("Envoyer par mail"),
                value: "mail",
                groupValue: livraison,
                onChanged: (value) {
                  setState(() {
                    livraison = value.toString();
                  });
                }),
            RadioListTile(
                title: Text("Envoyer par sms"),
                value: "sms",
                groupValue: livraison,
                onChanged: (value) {
                  setState(() {
                    livraison = value.toString();
                  });
                }),
            spaceWidget,
            TextFormField(
              controller: deliveryController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              decoration: InputDecoration(
                hintText: "Où livrer",
                label: const Text("Livraison"),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(space),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.box.price} $priceSymbol",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailsClientScreen(
                          box: widget.box,
                          livraison: livraison,
                          deliveyPlace: deliveryController.text,
                        )));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).primaryColor,
                child: const Text("Suivant"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
