import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../features/model/box_model.dart';
import '../../features/model/details_client_model.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

class ReservationScreen extends StatefulWidget {
  final Box box;
  final Order order;

  const ReservationScreen({Key? key, required this.box, required this.order})
      : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  TextEditingController dateController = TextEditingController(text: "");
  var initDate = DateTime.now().add(const Duration(days: 3));
  var firstDate = DateTime.now().add(const Duration(days: 2));
  var lastDate = DateTime(2026);

  @override
  void initState() {
    print(widget.box.startTime);
    print(widget.box.endTime);
    if (widget.box.startTime != null && widget.box.startTime!.isNotEmpty) {
      firstDate = DateTime.parse(widget.box.startTime.toString());
      initDate = firstDate;
    }

    if (widget.box.endTime != null && widget.box.endTime!.isNotEmpty) {
      lastDate = DateTime.parse(widget.box.endTime.toString());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(space),
          child: SingleChildScrollView(
            child: Column(
              children: [
                spaceWidget,
                Text(
                  "Reservation",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                /*spaceWidget,
                TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Choisir date de réservation"),
                    readOnly: true, // when true user cannot edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );

                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      } else {}
                    }),*/
                const SizedBox(
                  height: 30,
                ),
                SfDateRangePicker(
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    if (args.value is DateTime) {
                      setState(() => dateController.text = args.value.toString());
                    }
                  },
                  showNavigationArrow: true,
                  selectionMode: DateRangePickerSelectionMode.single,
                  //initialSelectedDate: initDate,
                  minDate: firstDate,
                  maxDate: lastDate,
                  monthCellStyle: const DateRangePickerMonthCellStyle(
                    //textStyle: TextStyle(color: Colors.lightGreen),
                    cellDecoration: BoxDecoration(color: Colors.green),
                    disabledDatesDecoration: BoxDecoration(color: Colors.red),
                    //cellDecoration: BoxDecoration(color:Colors.lightGreen),
                    disabledDatesTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
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
                    } else {
                      UiUtils.setSnackBar("Attention", "Choisir la data d'abord", context, false);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                      child: Text("Enregistrer"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  madeReservation() async {
    if (mounted) {
      UiUtils.modalLoading(context, "Chargement en cours");
    }

    final response = await http.post(
      Uri.parse(reserveOrderUrl),
      headers: ApiUtils.getHeaders(),
      body: {
        "order_id": widget.order.id.toString(),
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
