import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smartbox/ui/save_box/save_box_details_screen.dart';
import 'package:smartbox/ui/save_box/save_box_manually_screen.dart';

import '../../features/model/box_model.dart';
import '../../features/model/details_client_model.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class SaveBoxScreen extends StatefulWidget {
  const SaveBoxScreen({Key? key}) : super(key: key);

  @override
  State<SaveBoxScreen> createState() => _SaveBoxScreenState();
}

class _SaveBoxScreenState extends State<SaveBoxScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  String qrResult = '';

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
      //controller!.flipCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }

    super.reassemble();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrResult = scanData.code!;
      });
      checkNumberCode();
    });
  }

  checkNumberCode() async {
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
        });

    final response = await http
        .post(Uri.parse(checkNumberUrl), headers: ApiUtils.getHeaders(), body: {
      "number": qrResult,
    });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['order'];

      if (jsonResponse == null) {
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
                        Icons.error,
                        color: Colors.red,
                        size: 96,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Some text
                      const Text('Code invalide ou cadeau indisponible'),
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
      } else {
        Order order = Order.fromJson(jsonResponse);
        Box box = Box.fromJson(jsonResponse["box"]);
        if (order.orderConfirmation == null) {
          if (mounted) {
            Navigator.of(context).pop();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SaveBoxDetailsScreen(
                  box: box, order: order,
                ),
              ),
            );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrer un cadeau"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: qrResult.isEmpty
                      ? QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        )
                      : Center(
                          child: SizedBox(
                            child: InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: const Text("Relancer le scanner"),
                            ),
                          ),
                        ),
                ),
                /*Center(
                  child: Text(qrResult),
                ),*/
              ],
            ),
            Positioned(
                child: Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.2),
              padding: const EdgeInsets.all(space),
              margin: const EdgeInsets.all(space),
              child: const Text(
                "Scanner le code qr du cadeau",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )),
            Positioned(
              left: 0,
              right: 0,
              bottom: space,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: space),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    minimumSize: const Size.fromHeight(50), // N
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(sbInputRadius),
                    ),/// EW
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SaveBoxManuallyScreen()));
                  },
                  child: const Text(
                    'Entrer manuellement',
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
