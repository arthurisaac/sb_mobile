import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smartbox/features/model/new_order_model.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:smartbox/ui/utils/ui_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/widgets_utils.dart';

class PaymentChoiceScreen extends StatefulWidget {
  final NewOrder order;
  final Box box;
  final double total;
  final bool isExchange;
  const PaymentChoiceScreen(
      {Key? key, required this.order, required this.box, required this.total, this.isExchange = false})
      : super(key: key);

  @override
  State<PaymentChoiceScreen> createState() => _PaymentChoiceScreenState();
}

class _PaymentChoiceScreenState extends State<PaymentChoiceScreen> {
  TextEditingController phoneNumberController = TextEditingController(text: "");
  TextEditingController otpCodeController = TextEditingController(text: "");
  String payment = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votre moyen de paiement"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              spaceWidget,
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Moyen de paiement",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    spaceWidget,
                    spaceWidget,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          payment = "om";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          "images/orange_money.png",
                          width: 100,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              spaceWidget,
              payment == "om"
                  ? Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Paiement",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          spaceWidget,
                          Row(
                            children: [
                              Text("Montant à payer : "),
                              SizedBox(width: 10,),
                              Text("${widget.total} $priceSymbol", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          spaceWidget,
                          spaceWidget,
                          TextFormField(
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            showCursor: false,
                            readOnly: false,
                            decoration: InputDecoration(
                              labelText: "Téléphone",
                              hintText: "Numéro de téléphone",
                              errorText: null,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(sbInputRadius),
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
                          TextFormField(
                            controller: otpCodeController,
                            keyboardType: TextInputType.number,
                            showCursor: false,
                            readOnly: false,
                            decoration: InputDecoration(
                              labelText: "OPT",
                              hintText: "Code opt",
                              errorText: null,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(sbInputRadius),
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
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(sbInputRadius),
                              ),
                            ),
                            onPressed: () async {
                              if (phoneNumberController.text.isNotEmpty &&
                                  otpCodeController.text.isNotEmpty) {
                                savePayment();
                              } else {}
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              child: const Center(child: Text("Valider")),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future savePayment() async {
    UiUtils.modalLoading(context, "Chargement en cours");

    final body = {
      userKey: context.read<AuthCubit>().getId().toString(),
      orderKey: widget.order.id.toString(),
      boxKey: widget.box.id.toString(),
      phoneNumberKey: phoneNumberController.text,
      paymentMethodKey: payment,
      otpCodeKey: otpCodeController.text,
      amountKey: widget.total.toString()
    };
    var response = null;

    if (widget.isExchange == true) {
      response = await http.post(Uri.parse(boxExchangeUrl),
          headers: ApiUtils.getHeaders(), body: body);
    } else {
      response = await http.post(Uri.parse(savePaymentUrl),
          headers: ApiUtils.getHeaders(), body: body);
    }

    final responseJson = jsonDecode(response.body);
    //print(response.body);

    if (response.statusCode == 201) {
      if (mounted) {

        // Dialog de success
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
                      const Text('Votre achat a été effectué avec succès', style: TextStyle(fontWeight: FontWeight.bold),),
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
                          //if (!mounted) return;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MainScreen()));
                        },
                        child: const Text("Retour à l'accueil"),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    } else if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }

      var rpc = responseJson['data'];
      String body = rpc['message'];

      if (mounted) {
        Navigator.of(context).pop();

        if (body.isNotEmpty) {
          // Dialog de paiment échoué
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
                        Lottie.asset(
                          'images/animation_failure.json',
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          repeat: false,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Some text
                        const Text(
                          'Une erreur s\'est produite lors du paiement',
                          textAlign: TextAlign.center,
                        ),
                        spaceWidget,
                        Padding(
                          padding: const EdgeInsets.all(space),
                          child: Text(body),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(sbInputRadius),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Fermer", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      } else {
        final responseJson = jsonDecode(response.body);
        var message = responseJson['message'];

        if (!mounted) return;

        // Dialog erreur serveur
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
                        color: Colors.orange,
                        size: 96,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Une erreur s\'est produite lors du paiement',
                        textAlign: TextAlign.center,
                      ),
                      spaceWidget,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(message),
                      ),
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
                          Navigator.of(context).pop();
                        },
                        child: const Text("Fermer"),
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
