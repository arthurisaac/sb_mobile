import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartbox/features/model/category_model.dart';
import 'package:smartbox/ui/home/boxes_in_categories_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../utils/api_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                  /*return ListView.builder(
                    shrinkWrap: true,
                      itemCount: categoryList?.length,
                      itemBuilder: (context, index) {
                        CategoryModel category = categoryList![index];
                        return Text("${category.name}");
                      });*/
                  return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      category: category.id ?? 0, title: "${category.name}",
                                    )));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 100,
                                width: double.maxFinite,
                                padding: const EdgeInsets.only(bottom: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "$mediaUrl${category.image}"),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center
                                  ),
                                  borderRadius: BorderRadius.circular(sbInputRadius / 2),
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
}
