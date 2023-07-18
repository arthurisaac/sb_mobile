import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';
import 'package:http/http.dart' as http;

import '../../features/model/box_model.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

class ReservationScreen extends StatefulWidget {
  final Box box;

  const ReservationScreen({Key? key, required this.box}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  TextEditingController dateController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/login_bg.png"),
            fit: BoxFit.cover,
          )),
        ),
        Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(space),
            child: Column(
              children: [
                spaceWidget,
                Text(
                  "Reservation",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                spaceWidget,
                TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Choisir date de réservation"),
                    readOnly: true, // when true user cannot edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2026));

                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      } else {}
                    }),
                spaceWidget,
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: const Size.fromHeight(12),
                  ),
                  onPressed: () async {
                    if (dateController.text.isNotEmpty) {
                      madeReservation();
                    } else {}
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                      child: Text("Connexion"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  madeReservation() async {
    if (mounted) {
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
    }

    final response = await http.post(
      Uri.parse(reserveOrderUrl),
      headers: ApiUtils.getHeaders(),
      body: {
        "order_id": widget.box.id.toString(),
        "reservation_date": dateController.text,
      },
    );

    if (response.statusCode == 200) {
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
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 96,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Some text
                    const Text('Réservation enregistrée avec succès'),
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                      },
                      child: const Text("Fermer"),
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
      return null;
    }
  }
}
