import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:smartbox/features/model/boxes_model.dart';
import 'package:smartbox/features/model/category_model.dart';
import 'package:smartbox/features/model/sections_model.dart';
import 'package:smartbox/features/model/settings_model.dart';
import 'package:smartbox/ui/ad/ad_details_screen.dart';
import 'package:smartbox/ui/favorites/favorites_boxes_screen.dart';
import 'package:smartbox/ui/home/boxes_in_categories_screen.dart';
import 'package:smartbox/ui/search/search_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/model/slider_model.dart';
import '../utils/api_utils.dart';

class HomeScreen extends StatefulWidget {
  final SettingsModel settingsModel;

  const HomeScreen({Key? key, required this.settingsModel}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        // statusBarColor: Colors.red, // You can use this as well
        statusBarIconBrightness:
            Brightness.dark, // OR Vice Versa for ThemeMode.dark
        statusBarBrightness:
            Brightness.light, // OR Vice Versa for ThemeMode.dark
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black54
                        ],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height - 20));
                    },
                    blendMode: BlendMode.darken,
                    child: FutureBuilder<List<SliderModel>?>(
                        future: getSliders(),
                        builder: (context, snapshot) {
                          List<SliderModel>? list = snapshot.data;

                          if (snapshot.hasData) {
                            return CarouselSlider(
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                enlargeCenterPage: false,
                                disableCenter: true,
                                viewportFraction: 1.0,
                                autoPlayCurve: Curves.fastOutSlowIn,
                              ),
                              items: list
                                  ?.map(
                                    (item) => carouselItem(sliderModel: item),
                                  )
                                  .toList(),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Icon(
                                Icons.error_outline,
                                size: 50,
                              ),
                            );
                          }

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "$mediaUrl${widget.settingsModel.headerBackground}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: space),
                        child: Text(
                          "${widget.settingsModel.headerTitle}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                      ),
                      spaceWidget,
                      /*Container(
                        margin: const EdgeInsets.symmetric(horizontal: space),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Découvrir',
                          ),
                        ),
                      ),*/
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(space),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: space, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(sbInputRadius)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Chercher un cadeau"),
                            Icon(Icons.search)
                          ],
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FavoritesBoxesScreen()));
                    },
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.favorite,
                      size: 26,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: space),
              child: FutureBuilder<List<CategoryModel>?>(
                future: getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error);
                    }
                    return Text("Une erreur s'est produite ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    List<CategoryModel>? categoryList = snapshot.data;
                    if (snapshot.data != null) {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 24,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: categoryList?.length,
                          itemBuilder: (context, index) {
                            CategoryModel category = categoryList![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BoxesInCategories(
                                          category: category.id ?? 0,
                                          title: "${category.name}",
                                          settingsModel: widget.settingsModel,
                                        )));
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 130,
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.only(bottom: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "$mediaUrl${category.image}"),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                      borderRadius: BorderRadius.circular(
                                          sbInputRadius / 2),
                                    ),
                                  ),
                                  spaceWidget,
                                  Text("${category.name}"),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Text("Aucune catégorie");
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            FutureBuilder<List<Section>?>(
              future: getSections(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  if (kDebugMode) {
                    print(snapshot.error);
                  }
                  //return Text("Une erreur s'est produite ${snapshot.error}");
                  return Container();
                }
                if (snapshot.hasData) {
                  List<Section>? list = snapshot.data;
                  if (snapshot.data != null) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list?.length,
                        itemBuilder: (context, index) {
                          Section section = list![index];
                          List<Boxes>? boxList = section.boxes;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              spaceWidget,
                              Container(
                                padding: const EdgeInsets.all(space),
                                width: double.infinity,
                                color: Colors.white,
                                child: Text(
                                  "${section.title}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              spaceWidget,
                              Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(space),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 24,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: boxList?.length,
                                      itemBuilder: (context, index) {
                                        Boxes boxes = boxList![index];

                                        return BoxItem(box: boxes.box!);
                                      }))
                            ],
                          );
                        });
                  } else {
                    return const Text("Aucune catégorie");
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<CategoryModel>?> getCategories() async {
    final response = await http.post(
      Uri.parse(categoriesUrl),
      headers: ApiUtils.getHeaders(),
    );
    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez accéder aux données dans response.body
      // print(response.body);
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<CategoryModel> listCategories =
          jsonResponse.map((e) => CategoryModel.fromJson(e)).toList();

      return listCategories;
      //var responseJson =
    } else {
      return null;
    }
  }

  Future<List<Section>?> getSections() async {
    final response = await http.post(
      Uri.parse(sectionUrl),
      headers: ApiUtils.getHeaders(),
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Section> listSections =
          jsonResponse.map((e) => Section.fromJson(e)).toList();

      return listSections;
      //var responseJson =
    } else {
      return null;
    }
  }

  Future<List<SliderModel>?> getSliders() async {
    try {
      final body = {};
      final response = await http.post(Uri.parse(sliderMainPageUrl),
          body: body, headers: ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<SliderModel> list =
          jsonResponse.map((e) => SliderModel.fromJson(e)).toList();

      return list;
    } catch (e) {
      //throw AlertException(errorMessageCode: e.toString());
      return null;
    }
  }

  Widget carouselItem({required SliderModel sliderModel}) {
    if (sliderModel.type == "categorie") {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BoxesInCategories(
                    category: sliderModel.typeId ?? 0,
                    title: '',
                    settingsModel: widget.settingsModel,
                  )));
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("$mediaUrl${sliderModel.image}"),
                fit: BoxFit.cover),
            color: Colors.blueGrey,
            //borderRadius: BorderRadius.circular(space),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("$mediaUrl${sliderModel.image}"),
              fit: BoxFit.cover),
          color: Colors.blueGrey,
          //borderRadius: BorderRadius.circular(space),
        ),
      );
    }
  }
}
