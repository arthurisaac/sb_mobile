import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/ui/boxes/box_details_with_exchange.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';
import '../../features/model/details_client_model.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

import '../utils/widgets_utils.dart';

class BoxesWithSamePriceScreen extends StatefulWidget {
  final String price;
  final Order order;

  const BoxesWithSamePriceScreen(
      {Key? key, required this.price, required this.order})
      : super(key: key);

  @override
  State<BoxesWithSamePriceScreen> createState() =>
      _BoxesWithSamePriceScreenState();
}

class _BoxesWithSamePriceScreenState extends State<BoxesWithSamePriceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Box>?>(
        future: getBoxes(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Box>? list = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(space),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 24,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: list?.length,
                  itemBuilder: (context, index) {
                    Box box = list![index];
                    return BoxItemExchange(
                      box: box,
                      order: widget.order,
                    );
                  }),
            );
          }

          if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            return Scaffold(
              body: Center(
                child: Icon(
                  Icons.error_outline,
                  size: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<Box>?> getBoxes() async {
    final body = {
      "price": widget.price,
      userKey: context.read<AuthCubit>().getId().toString()
    };
    final response = await post(Uri.parse(boxWithSamePriceUrl),
        headers: ApiUtils.getHeaders(), body: body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Box> list = jsonResponse.map((e) => Box.fromJson(e)).toList();

      return list;
    } else {
      return null;
    }
  }
}

class BoxItemExchange extends StatefulWidget {
  final Box box;
  final Order order;

  const BoxItemExchange({Key? key, required this.box, required this.order})
      : super(key: key);

  @override
  State<BoxItemExchange> createState() => _BoxItemExchangeState();
}

class _BoxItemExchangeState extends State<BoxItemExchange> {
  late Box box;

  @override
  void initState() {
    box = widget.box;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                BoxDetailsWithExchange(box: box, order: widget.order)));
      },
      child: Card(
        elevation: 5,
        shadowColor: Colors.black,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$mediaUrl${widget.box.image}"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.box.name}"),
                      smallSpaceWidget,
                      RatingBarIndicator(
                        rating: 2.75,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 12.0,
                        direction: Axis.horizontal,
                      ),
                      spaceWidget,
                      (widget.box.discount! > 0)
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${widget.box.price} $priceSymbol",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          wordSpacing: -2,
                                          color: Colors.blueGrey,
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${widget.box.discount} $priceSymbol",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        wordSpacing: -2,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            )
                          : Text(
                              "${widget.box.price} $priceSymbol",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    wordSpacing: -2,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: -17,
              child: MaterialButton(
                onPressed: () {
                  addFavorite();
                  if (box.favorites == null) {
                    Map<String, dynamic> favorite = {};
                    box.favorites = favorite;
                  } else {
                    box.favorites = null;
                  }

                  setState(() {});
                },
                color: Colors.white,
                padding: const EdgeInsets.all(2),
                shape: const CircleBorder(),
                child: Icon(
                  Icons.favorite,
                  size: 20,
                  color: box.favorites != null ? Colors.yellow : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addFavorite() async {
    final body = {
      userKey: context.read<AuthCubit>().getId().toString(),
      boxKey: widget.box.id.toString()
    };
    await post(Uri.parse(addFavoriteUrl),
        headers: ApiUtils.getHeaders(), body: body);
  }
}
