import 'package:flutter/material.dart';
import 'package:smartbox/ui/boxes/boxes_with_same_price_screen.dart';

import '../../features/model/details_client_model.dart';
import '../utils/constants.dart';

class BoxExchangePresentationScreen extends StatefulWidget {
  final String price;
  final Order order;

  const BoxExchangePresentationScreen(
      {Key? key, required this.price, required this.order})
      : super(key: key);

  @override
  State<BoxExchangePresentationScreen> createState() =>
      _BoxExchangePresentationScreenState();
}

class _BoxExchangePresentationScreenState
    extends State<BoxExchangePresentationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            /*Lottie.asset(
              'images/animation_scan.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),*/
            const Icon(
              Icons.find_replace,
              size: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Échanger votre cadeau",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Vous pouvez échanger votre avec un autre de même valeur",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 0,
              child: ButtonTheme(
                minWidth: 320.0,
                height: 50.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BoxesWithSamePriceScreen(
                          price: widget.price,
                          order: widget.order,
                        ),
                      ),
                    );
                  },
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
