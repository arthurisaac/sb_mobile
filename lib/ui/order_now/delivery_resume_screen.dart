import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/features/model/box_model.dart';
import 'package:smartbox/features/model/details_client_model.dart';
import 'package:smartbox/features/model/new_order_model.dart';
import 'package:smartbox/ui/payment/payment_choice_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../utils/ui_utils.dart';

class DeliveryResumeScreen extends StatefulWidget {
  final Box box;
  final Order order;
  final String livraison;
  final String deliveryPlace;
  const DeliveryResumeScreen(
      {Key? key,
      required this.box,
      required this.order,
      required this.livraison,
      required this.deliveryPlace})
      : super(key: key);

  @override
  State<DeliveryResumeScreen> createState() => _DeliveryResumeScreenState();
}

class _DeliveryResumeScreenState extends State<DeliveryResumeScreen> {
  double total = 0;

  @override
  void initState() {
    total = (widget.box.discount! > 0)
        ? double.tryParse(widget.box.discount.toString()) ?? 0
        : double.tryParse(widget.box.price.toString()) ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Récapitulatif"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceWidget,
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.network(
                      "$mediaUrl${widget.box.image}",
                      height: 50,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.box.name}",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text("Livraison : ${widget.livraison}"),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expéditeur",
                      style: Theme.of(context)  
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    spaceWidget,
                    Text(context.read<AuthCubit>().getEmail())
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Détails client",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    spaceWidget,
                    Text("Nom ${widget.order.nom}"),
                    spaceWidget,
                    Text("Prénom ${widget.order.prenom}"),
                    spaceWidget,
                    Text("Pays ${widget.order.pays}"),
                    spaceWidget,
                    Text("Ville ${widget.order.ville}"),
                    spaceWidget,
                    Text("Téléphone ${widget.order.telephone}"),
                    spaceWidget,
                    Text("Mail ${widget.order.mail}"),
                    spaceWidget,
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Montant total",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    spaceWidget,
                    const Row(
                      children: [],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sous-total"),
                        Text("$total $priceSymbol")
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            padding: const EdgeInsets.all(space),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Montant total",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("$total $priceSymbol")
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(space),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$total $priceSymbol",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                InkWell(
                    onTap: () {
                      saveDetails();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(sbInputRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Text("Payer maintenant", style: TextStyle(color: Colors.white)),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future saveDetails() async {
    UiUtils.modalLoading(context, "Chargement en cours");

    final body = {
      userKey: context.read<AuthCubit>().getId().toString(),
      boxKey: widget.box.id.toString(),
      deliveryKey: widget.livraison,
      deliveryPlaceKey: widget.deliveryPlace,
      nomClientKey: widget.order.nom,
      prenomClientKey: widget.order.prenom,
      villeClientKey: widget.order.ville,
      paysClientKey: widget.order.pays,
      telephoneClientKey: widget.order.telephone,
      mailClientKey: widget.order.mail,
      promoCodeKey: "",
      totalKey: total.toString(),
    };
    final response = await http.post(Uri.parse(saveOrderUrl),
        headers: ApiUtils.getHeaders(), body: body);
    if (kDebugMode) {
      print(response.statusCode);
    }
    if (!mounted) return null;
    Navigator.of(context).pop();

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      NewOrder order = NewOrder.fromJson(responseJson['order']);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentChoiceScreen(
                order: order,
                box: widget.box,
                total: total,
              )));

      return order;
    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }

      if (mounted) {
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
                      const Text('Une erreur s\'est produite'),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Text("Fermer", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }

      return null;
    }
  }
}
