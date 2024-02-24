import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/features/model/images_model.dart';
import 'package:smartbox/ui/auth/manual_login_screen.dart';
import 'package:smartbox/ui/order_now/delivery_mode_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
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
        title: Text(box.name.toString()),
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
                      (item) =>
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("$mediaUrl${item.image}"),
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
                  activeColor: Theme
                      .of(context)
                      .primaryColor,
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
                      style: Theme
                          .of(context)
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
                          itemBuilder: (context, index) =>
                          const Icon(
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
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
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
        (widget.box.discount! > 0)
            ? Text(
          "${widget.box.discount} $priceSymbol",
          style: Theme
              .of(context)
              .textTheme
              .labelLarge
              ?.copyWith(
              fontWeight: FontWeight.w800, color: Colors.red),
        )
            : Text(
          "${widget.box.price} $priceSymbol",
          style: Theme
              .of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        InkWell(
          onTap: () {
            if (context
                .read<AuthCubit>()
                .state is Authenticated) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DeliveryModeScreen(
                        box: widget.box,
                      )));
            } else {
              AlertDialog alert = AlertDialog(
                title: const Text("Attention"),
                content: const Text(
                    "Vous avez besoin d'être connecté avant d'acheter une box"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ManualLoginScreen()));
                    },
                    child: Text(
                      "Connexion",
                      style:
                      TextStyle(color: Theme
                          .of(context)
                          .primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Annuler",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              );
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sbInputRadius),
                color: Theme.of(context).primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Text("Acheter", style: TextStyle(color: Colors.white),),
          ),
        ),
      )
      ],
    ),)
    ,
    );
  }
}
