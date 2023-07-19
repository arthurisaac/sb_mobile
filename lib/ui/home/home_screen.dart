import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartbox/features/model/box_model.dart';
import 'package:smartbox/features/model/boxes_model.dart';
import 'package:smartbox/features/model/category_model.dart';
import 'package:smartbox/features/model/sections_model.dart';
import 'package:smartbox/features/model/settings_model.dart';
import 'package:smartbox/ui/ad/ad_details_screen.dart';
import 'package:smartbox/ui/home/boxes_in_categories_screen.dart';
import 'package:smartbox/ui/search/search_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

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
    return SafeArea(
      child: Scaffold(
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
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          /*gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),*/
                          image: DecorationImage(
                            image: NetworkImage(
                                "$mediaUrl${widget.settingsModel.headerBackground}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                        Container(
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
                        ),
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: space, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(sbInputRadius)
                          ),
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
                      onPressed: () {},
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.favorite,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              widget.settingsModel.bannerAdEnable == 1 ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdDetailsScreen(ad: widget.settingsModel.bannerAdDetail.toString() ?? "No details")));
                },
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.orange
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Text("${widget.settingsModel.bannerAd}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),),
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.all(space),
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
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
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
                    return Text("Une erreur s'est produite ${snapshot.error}");
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
                                  child: Text("${section.title}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                spaceWidget,
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(space),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                      ),
                                      itemCount: boxList?.length,
                                      itemBuilder: (context, index) {
                                        Boxes boxes = boxList![index];

                                        return BoxItem(box: boxes.box!);
                                      })
                                )
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
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      print('Request failed with status: ${response.statusCode}.');
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
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
