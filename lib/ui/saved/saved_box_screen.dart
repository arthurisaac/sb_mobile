import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/ui/boxes/box_details_with_edit_reservation_screen.dart';
import 'package:smartbox/ui/helper/please_login_screen.dart';
import 'package:smartbox/ui/utils/api_body_parameters.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../features/model/details_client_model.dart';
import '../boxes/box_details_reservation_screen.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

class SavedBoxScreen extends StatefulWidget {
  const SavedBoxScreen({Key? key}) : super(key: key);

  @override
  State<SavedBoxScreen> createState() => _SavedBoxScreenState();
}

class _SavedBoxScreenState extends State<SavedBoxScreen> {
  TextEditingController commentController = TextEditingController(text: "");
  String notation = "5";

  @override
  Widget build(BuildContext context) {
    return context.read<AuthCubit>().state is Authenticated
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Cadeaux enregistrés"),
              centerTitle: true,
            ),
            body: Center(
                child: Padding(
              padding: const EdgeInsets.all(space),
              child: FutureBuilder<List<Order>?>(
                  future: getBoxes(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Une erreur s'est produite"),
                      );
                    }
                    if (snapshot.hasData) {
                      List<Order>? list = snapshot.data;
                      //print(list!.length);

                      if (list!.isEmpty) {
                        return const Center(
                          child: Text("Aucun cadeau enregistré"),
                        );
                      } else {
                        List<Order>? enCours = [];
                        List<Order>? reserve = [];
                        List<Order>? consomme = [];

                        for (var order in list) {
                          if (order.status == 0) {
                            enCours.add(order);
                          } else if (order.status == 1) {
                            reserve.add(order);
                          } else if (order.status == 2) {
                            consomme.add(order);
                          }
                        }

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              enCours.isNotEmpty ? spaceWidget : Container(),
                              enCours.isNotEmpty
                                  ? const Text(
                                      "En cours",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  : const Text(""),
                              enCours.isNotEmpty ? spaceWidget : Container(),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: enCours.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Order order = enCours[index];

                                  Box? box = order.box;

                                  return Card(
                                    elevation: 50,
                                    shadowColor: Colors.black,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.only(bottom: 15),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("$mediaUrl${box!.image}"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: space),
                                          child: Text(
                                            "${box.price} $priceSymbol",
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: space),
                                          child: Divider(),
                                        ),
                                        spaceWidget,
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: space),
                                          child: Text(
                                            "${box.name}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        spaceWidget,
                                        spaceWidget,
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Theme.of(context).primaryColor,
                                              minimumSize: const Size.fromHeight(12),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => BoxDetailsReservationScreen(
                                                        box: box,
                                                        order: order,
                                                      )));
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(8),
                                              child: const Center(
                                                child: Text("Voir"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        spaceWidget
                                      ],
                                    ),
                                  );
                                },
                              ),
                              enCours.isNotEmpty
                                  ? const SizedBox(
                                      height: 20,
                                    )
                                  : Container(),
                              reserve.isNotEmpty
                                  ? const Text(
                                      "Réservé",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  : const Text(""),
                              reserve.isNotEmpty ? spaceWidget : Container(),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: reserve.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Order order = reserve[index];
                                  Box? box = order.box;

                                  return Card(
                                    elevation: 50,
                                    shadowColor: Colors.black,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BoxDetailsWithEditReservationScreen(
                                              box: box,
                                              order: order,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: double.maxFinite,
                                            padding: const EdgeInsets.only(bottom: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage("$mediaUrl${box!.image}"),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: space),
                                            child: Text(
                                              "Cadeau réservé",
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: space),
                                            child: Divider(),
                                          ),
                                          spaceWidget,
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: space),
                                            child: Text(
                                              "${box.name}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          spaceWidget,
                                          order.reservation != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(horizontal: space),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.date_range,
                                                            size: 15,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${order.reservation}",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  color: Theme.of(context)
                                                                      .primaryColor,
                                                                ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          spaceWidget,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              consomme.isNotEmpty
                                  ? const Text(
                                      "Consommé",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  : const Text(""),
                              consomme.isNotEmpty ? spaceWidget : Container(),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: consomme.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Order order = consomme[index];
                                  Box? box = order.box;

                                  return Card(
                                    elevation: 50,
                                    shadowColor: Colors.black,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => detail(
                                              context: context,
                                              order: order,
                                              box: box,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: double.maxFinite,
                                            padding: const EdgeInsets.only(bottom: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage("$mediaUrl${box!.image}"),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: space),
                                            child: Text(
                                              "Cadeau consommé",
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: space),
                                            child: Divider(),
                                          ),
                                          spaceWidget,
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: space),
                                            child: Text(
                                              "${box.name}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          spaceWidget,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            )),
          )
        : const PleaseLoginScreen();
  }

  Widget detail({required BuildContext context, required Order order, required Box box}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votre cadeau"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  disableCenter: true,
                  autoPlay: true,
                  viewportFraction: 1.0,
                ),
                items: box.images
                    ?.map(
                      (item) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("$mediaUrl${item.image}"), fit: BoxFit.cover),
                        ),
                        //child: Text(item.toString()),
                      ),
                    )
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(space),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${box.name}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: box.notation!.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 13.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${box.notationCount}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (box.discount != null && box.discount! > 0)
                        ? Text(
                            "${box.price} $priceSymbol",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(space),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceWidget,
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("${box.maxPerson} personnes"),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text("|"),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.hourglass_bottom,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Validité : ${box.validity} mois")
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Qu'est-ce qui est inclus ?",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    box.isInside != null && box.isInside!.isNotEmpty
                        ? Html(
                            data: box.isInside,
                            style: {
                              "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                              "ul": Style(
                                padding: HtmlPaddings.only(left: 15),
                                margin: Margins.zero,
                                listStyleImage: const ListStyleImage("${serverUrl}images/list.jpg"),
                              ),
                              "li": Style(
                                padding: HtmlPaddings.only(
                                  left: 5,
                                ),
                              ),
                            },
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Que devrais-je savoir ?",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    box.mustKnow!.isNotEmpty
                        ? Html(
                            data: box.mustKnow,
                            style: {
                              "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                              "ul": Style(
                                  padding: HtmlPaddings.only(left: 15),
                                  margin: Margins.zero,
                                  listStyleImage:
                                      const ListStyleImage("${serverUrl}images/list.png")),
                              "li": Style(padding: HtmlPaddings.only(left: 5)),
                            },
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Html(
                      data: box.description,
                      style: {
                        "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Donnez son avis",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    spaceWidget,
                    TextFormField(
                      controller: commentController,
                      keyboardType: TextInputType.multiline,
                      showCursor: false,
                      readOnly: false,
                      decoration: InputDecoration(
                        labelText: "Commentaire",
                        hintText: "Donnez votre avis sur le cadeau",
                        errorText: null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(sbInputRadius),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RatingBar.builder(
                      initialRating: 3,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return const Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return const Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return const Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return const Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          default:
                            return const Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            );
                        }
                      },
                      onRatingUpdate: (rating) {
                        setState(() => notation = rating.toString());
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size.fromHeight(12),
                      ),
                      onPressed: () async {
                        sendCommentAndNotation(box.id.toString());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        child: const Center(
                          child: Text("Envoyer"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Order>?> getBoxes() async {
    final body = {
      orderConfirmationKey: context.read<AuthCubit>().getId().toString(),
    };
    try {
      final response = await http.post(
        Uri.parse(savedOrderUrl),
        headers: ApiUtils.getHeaders(),
        body: body,
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        var jsonResponse = responseJson['data'] as List<dynamic>;

        List<Order> list = jsonResponse.map((e) => Order.fromJson(e)).toList();

        return list;
      } else {
        print('not ok 200');
        return null;
      }
    } catch (e) {
      print("Une erreur s'est produite");
      print(e);
      return null;
    }
  }

  sendCommentAndNotation(String box) async {
    if (mounted) {
      UiUtils.modalLoading(context, "Chargement en cours");
    }

    final response =
        await http.post(Uri.parse(sendCommentUrl), headers: ApiUtils.getHeaders(), body: {
      "box": box,
      "user": context.read<AuthCubit>().getId().toString(),
      "comment": commentController.text,
      "notation": notation
    });

    if (mounted) {
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (!mounted) return;

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
                    Icons.check_circle_outline,
                    color: Colors.greenAccent,
                    size: 96,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Some text
                  const Text('Merci pour vos commentaires'),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      //if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(sbInputRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Text("Ok", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  }
}
