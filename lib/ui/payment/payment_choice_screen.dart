import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/features/model/details_client_model.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';

import 'package:http/http.dart' as http;

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/widgets_utils.dart';

class PaymentChoiceScreen extends StatefulWidget {
  final Order order;
  final Box box;
  final double total;
  const PaymentChoiceScreen({Key? key, required this.order, required this.box, required this.total}) : super(key: key);

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
                    Text("Moyen de paiement", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),),
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
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Image.asset("images/orange_money.png", width: 100,),
                      ),
                    )
                  ],
                ),
              ),
              spaceWidget,
              payment == "om" ? Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Paiement", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),),
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
                        primary: Theme
                            .of(context)
                            .primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(sbInputRadius),
                        ),
                      ),
                      onPressed: () async {
                        if (phoneNumberController.text.isNotEmpty && otpCodeController.text.isNotEmpty) {
                          savePayment();
                        } else {}
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        child: const Center(child: Text("Connexion")),
                      ),
                    )
                  ],
                ),
              ): Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future savePayment() async {
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
        }
    );

    final body = {
      userKey: context.read<AuthCubit>().getId().toString(),
      orderKey: widget.order.id.toString(),
      phoneNumberKey: phoneNumberController.text,
      paymentMethodKey: payment,
      otpCodeKey: otpCodeController.text,
      amountKey: widget.total.toString()
    };

    final response = await http.post(
        Uri.parse(savePaymentUrl),
        headers: ApiUtils.getHeaders(),
        body: body
    );

    if (response.statusCode == 201) {

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
                      const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 96,),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text('Paiement enregistré'),
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
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const MainScreen())
                          );
                        },
                        child: const Text("Fermer"),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      }

    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
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
                      const Icon(Icons.error, color: Colors.red, size: 96,),
                      const SizedBox(
                        height: 15,
                      ),
                      // Some text
                      const Text('Une erreur s\'est produite'),
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
                          Navigator.of(context).pop();
                        },
                        child: const Text("Fermer"),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      }


      return null;
    }
  }
}
