import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/features/model/box_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:smartbox/ui/boxes/box_details_screen.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/settings_model.dart';
import '../../features/model/sub_category_model.dart';
import '../ad/ad_details_screen.dart';
import '../sub_categories/sub_categories_items_screen.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

class BoxesInCategories extends StatefulWidget {
  final int category;
  final String title;
  final SettingsModel settingsModel;

  const BoxesInCategories(
      {Key? key,
      required this.category,
      required this.title,
      required this.settingsModel})
      : super(key: key);

  @override
  State<BoxesInCategories> createState() => _BoxesInCategoriesState();
}

class _BoxesInCategoriesState extends State<BoxesInCategories> {
  List<Subcategory> subCats = [];
  List<Box> boxList = [];

  @override
  void initState() {
    getBoxes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            widget.settingsModel.bannerAdEnable == 1
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdDetailsScreen(
                              ad: widget.settingsModel.bannerAdDetail
                                  .toString())));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.orange),
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "${widget.settingsModel.bannerAd}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
            spaceWidget,
            Padding(
              padding: const EdgeInsets.all(space),
              child: boxList.isNotEmpty
                  ? Column(
                      children: [
                        GridView.builder(
                            /* gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),*/
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 10,
                              // width / height: fixed for *all* items
                              childAspectRatio: 0.75,
                            ),
                            shrinkWrap: true,
                            itemCount: boxList.length,
                            itemBuilder: (context, index) {
                              Box box = boxList[index];
                              return BoxItem(box: box);
                            }),
                        spaceWidget,
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: subCats.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SubCategoriesItemsScreen(
                                      subCats: subCats[index].items,
                                      title: subCats[index].title ?? "",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "$mediaUrl${subCats[index].image}"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(
                                    "${subCats[index].title}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 8.0,
                                          color: Color.fromARGB(
                                              125, 255, 255, 255),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              /*child: FutureBuilder<List<Box>?>(
                future: getBoxes(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error);
                    }
                    return Text("Une erreur s'est produite ${snapshot.error}");
                  }

                  if (snapshot.hasData) {
                    List<Box>? boxList = snapshot.data;
                    if (snapshot.data != null && boxList!.isNotEmpty) {
                      return Column(
                        children: [
                          GridView.builder(
                              */
              /* gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),*/
              /*
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 10,
                                // width / height: fixed for *all* items
                                childAspectRatio: 0.75,
                              ),
                              shrinkWrap: true,
                              itemCount: boxList.length,
                              itemBuilder: (context, index) {
                                Box box = boxList[index];
                                return BoxItem(box: box);
                              }),
                          spaceWidget,
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: subCats.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "$mediaUrl${subCats[index].image}"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text(
                            "Nous n'avons aucun cadeau disponible pour cette catégorie"),
                      );
                    }
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),*/
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Box>?> getBoxes() async {
    final body = {
      categoryKey: widget.category.toString(),
      userKey: context.read<AuthCubit>().getId().toString()
    };
    final response = await http.post(Uri.parse(boxesInCategoryUrl),
        headers: ApiUtils.getHeaders(), body: body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      var boxesJson = responseJson['boxes'] as List<dynamic>;
      var subCategoriesJson = responseJson['sub_categories'] as List<dynamic>;

      List<Box> list = boxesJson.map((e) => Box.fromJson(e)).toList();

      setState(() {
        subCats =
            subCategoriesJson.map((e) => Subcategory.fromJson(e)).toList();
        boxList = list;
      });

      return list;
    } else {
      return null;
    }
  }
}

class BoxItem extends StatefulWidget {
  final Box box;

  const BoxItem({Key? key, required this.box}) : super(key: key);

  @override
  State<BoxItem> createState() => _BoxItemState();
}

class _BoxItemState extends State<BoxItem> {
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
            builder: (context) => BoxDetailsScreen(box: widget.box)));
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
    await http.post(Uri.parse(addFavoriteUrl),
        headers: ApiUtils.getHeaders(), body: body);
  }
}
