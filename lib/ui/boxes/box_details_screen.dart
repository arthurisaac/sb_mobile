import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/features/model/images_model.dart';
import 'package:smartbox/ui/order_now/delivery_mode_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/model/box_model.dart';

class BoxDetailsScreen extends StatefulWidget {
  final Box box;

  const BoxDetailsScreen({Key? key, required this.box}) : super(key: key);

  @override
  State<BoxDetailsScreen> createState() => _BoxDetailsScreenState();
}

class _BoxDetailsScreenState extends State<BoxDetailsScreen> {
  late List<Images>? imgList = [];
  late Box box;

  @override
  void initState() {
    super.initState();

    imgList = widget.box.images;
    box = widget.box;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                            rating: box.notation as double,
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
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(space),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${box.price} $priceSymbol", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveryModeScreen(box: widget.box,)));
            }, child: Container(
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).primaryColor,
              child: const Text("Acheter"),
            ))
          ],
        ),
      ),
    );
  }
}
