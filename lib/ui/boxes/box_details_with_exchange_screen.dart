import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/features/model/images_model.dart';
import 'package:smartbox/ui/order_now/delivery_mode_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/model/box_model.dart';
import '../../features/model/details_client_model.dart';
import '../reserve/reservation_screen.dart';
import 'box_details_reservation_screen.dart';

class BoxDetailsWithExchangeScreen extends StatefulWidget {
  final Box box;
  final Order order;

  const BoxDetailsWithExchangeScreen(
      {Key? key, required this.box, required this.order})
      : super(key: key);

  @override
  State<BoxDetailsWithExchangeScreen> createState() =>
      _BoxDetailsWithExchangeScreenState();
}

class _BoxDetailsWithExchangeScreenState
    extends State<BoxDetailsWithExchangeScreen> {
  late List<Images>? imgList = [];
  late Box box;
  int _index = 0;

  @override
  void initState() {
    super.initState();

    imgList = widget.box.images;
    box = widget.box;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.box.name ?? ""),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  disableCenter: true,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() => _index = index);
                  },
                ),
                items: imgList
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
              Center(
                child: CarouselIndicator(
                  width: 20,
                  height: 6,
                  color: Colors.black,
                  activeColor: Theme.of(context).primaryColor,
                  count: imgList!.length,
                  index: _index,
                ),
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
                          rating: double.tryParse(box.notation.toString()) ?? 0,
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
                    (box.discount! > 0)
                        ? Row(
                            children: [
                              Text(
                                "${box.price} $priceSymbol",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${box.discount} $priceSymbol",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          )
                        : Text(
                            "${box.price} $priceSymbol",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                              "body": Style(
                                  padding: HtmlPaddings.zero,
                                  margin: Margins.zero),
                              "ul": Style(
                                  padding: HtmlPaddings.only(left: 15),
                                  margin: Margins.zero,
                                  listStyleImage: const ListStyleImage(
                                      "${serverUrl}images/list.jpg")),
                              "li": Style(padding: HtmlPaddings.only(left: 5)),
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
                              "body": Style(
                                  padding: HtmlPaddings.zero,
                                  margin: Margins.zero),
                              "ul": Style(
                                  padding: HtmlPaddings.only(left: 15),
                                  margin: Margins.zero,
                                  listStyleImage: const ListStyleImage(
                                      "${serverUrl}images/list.png")),
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
                        "body": Style(
                            padding: HtmlPaddings.zero, margin: Margins.zero),
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(space),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.box.discount! > 0)
                    ? Text(
                        "${widget.box.discount} $priceSymbol",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800, color: Colors.red),
                      )
                    : Text(
                        "${widget.box.price} $priceSymbol",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Theme.of(context).primaryColor,
                    child: const Text("Echanger avec un autre"),
                  ),
                )
              ],
            ),
            spaceWidget,
            ElevatedButton(
              onPressed: () async {
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
                    return ReservationScreen(
                      box: box,
                      order: widget.order,
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Center(
                  child: Text("Modifier sa réservation"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
