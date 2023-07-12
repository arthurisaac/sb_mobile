import 'package:flutter/material.dart';
import 'package:smartbox/features/model/details_client_model.dart';
import 'package:smartbox/ui/order_now/delivery_resume_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/strings_constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/model/box_model.dart';

class DetailsClientScreen extends StatefulWidget {
  final Box box;
  final String livraison;
  final String deliveyPlace;
  const DetailsClientScreen({Key? key, required this.box, required this.livraison, required this.deliveyPlace}) : super(key: key);

  @override
  State<DetailsClientScreen> createState() => _DetailsClientScreenState();
}

class _DetailsClientScreenState extends State<DetailsClientScreen> {
  TextEditingController nomController = TextEditingController(text: "");
  TextEditingController prenomController = TextEditingController(text: "");
  //TextEditingController adresseController = TextEditingController(text: "");
  TextEditingController villeController = TextEditingController(text: "");
  TextEditingController paysController = TextEditingController(text: "");
  TextEditingController telephoneController = TextEditingController(text: "");
  TextEditingController mailController = TextEditingController(text: "");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails du client"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(space),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceWidget,
                Text("Détails de la facture", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),),
                spaceWidget,
                spaceWidget,
                TextFormField(
                  controller: nomController,
                  keyboardType: TextInputType.text,
                  showCursor: false,
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: "Nom",
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
                spaceWidget,
                TextFormField(
                  controller: prenomController,
                  keyboardType: TextInputType.text,
                  showCursor: false,
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: "Prénom",
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
                spaceWidget,
                TextFormField(
                  controller: villeController,
                  keyboardType: TextInputType.text,
                  showCursor: false,
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: "Ville",
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
                spaceWidget,
                TextFormField(
                  controller: paysController,
                  keyboardType: TextInputType.text,
                  showCursor: false,
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: "Pays",
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
                spaceWidget,
                TextFormField(
                  controller: telephoneController,
                  keyboardType: TextInputType.phone,
                  showCursor: false,
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: "Téléphone",
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
                spaceWidget,
                TextFormField(
                  controller: mailController,
                  keyboardType: TextInputType.emailAddress,
                  showCursor: false,
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: "Mail",
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
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(space),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${widget.box.price} $priceSymbol", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),),
            ElevatedButton(onPressed: () {
              Order order = Order(id: 0, nom: nomController.text, prenom: prenomController.text, ville: villeController.text, pays: paysController.text, mail: mailController.text, telephone: telephoneController.text);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveryResumeScreen(box: widget.box, order: order, livraison: widget.livraison, deliveryPlace: widget.deliveyPlace,)));
            }, child: Container(
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).primaryColor,
              child: const Text("Récapitulatif"),
            ))
          ],
        ),
      ),
    );
  }
}
