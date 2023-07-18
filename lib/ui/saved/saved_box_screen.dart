import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/ui/home/boxes_in_categories_screen.dart';
import 'package:smartbox/ui/utils/api_body_parameters.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';

import 'package:http/http.dart' as http;

import '../../features/model/details_client_model.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

class SavedBoxScreen extends StatefulWidget {
  const SavedBoxScreen({Key? key}) : super(key: key);

  @override
  State<SavedBoxScreen> createState() => _SavedBoxScreenState();
}

class _SavedBoxScreenState extends State<SavedBoxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Cadeaux enregistrés"),
        centerTitle: true,
      ),
      body: Padding(
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

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Order order = list![index];

                    Box? box = order.box;

                    return Card(
                      elevation: 50,
                      shadowColor: Colors.black,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            builder: (context) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child: SingleChildScrollView(
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
                                                    image: NetworkImage("$mediaUrl${item.image}" ??
                                                        "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
                                                    fit: BoxFit.cover),
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
                                                      Icon(
                                                        Icons.people,
                                                        size: 14,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("${box.maxPerson} personnes"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text("|"),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.hourglass_bottom,
                                                        size: 14,
                                                      ),
                                                      SizedBox(
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
                                              box.isInside != null && box.isInside!.isNotEmpty ? Html(
                                                data: box.isInside,
                                                style: {
                                                  "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                                                  "ul": Style(padding: HtmlPaddings.only(left: 15), margin: Margins.zero, listStyleImage: const ListStyleImage("${serverUrl}images/list.jpg")),
                                                  "li": Style(padding: HtmlPaddings.only(left: 5)),
                                                },
                                              )  : Container(),
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
                                              box.mustKnow!.isNotEmpty ? Html(
                                                data: box.mustKnow,
                                                style: {
                                                  "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                                                  "ul": Style(padding: HtmlPaddings.only(left: 15), margin: Margins.zero, listStyleImage: const ListStyleImage("${serverUrl}images/list.png")),
                                                  "li": Style(padding: HtmlPaddings.only(left: 5)),
                                                },
                                              )  : Container(),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Html(
                                                data: box.description,
                                                style: {
                                                  "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 60,)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: space),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: space),
                              child: Text(
                                "${box.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            spaceWidget,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: space),
                              child: Text("${box.description}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey.shade500,
                                      ),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            spaceWidget,
                            Padding(
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
                            ),
                            spaceWidget,
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Future<List<Order>?> getBoxes() async {
    final body = {
      orderConfirmationKey: context.read<AuthCubit>().getId().toString(),
    };
    final response = await http.post(
      Uri.parse(savedOrderUrl),
      headers: ApiUtils.getHeaders(),
      body: body,
    );
    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez accéder aux données dans response.body
      print(response.body);
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Order> list = jsonResponse.map((e) => Order.fromJson(e)).toList();

      return list;
    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
