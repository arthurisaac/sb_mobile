import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartbox/features/model/category_model.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<CategoryModel>?>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Une erreur s'est produite ${snapshot.error}");
            } else if (snapshot.hasData) {
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: categoryList?.length,
                    itemBuilder: (context, index) {
                      CategoryModel category = categoryList![index];
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(sbInputRadius)),
                        child: Text("${category.name}"),
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
    );
  }

  Future<List<CategoryModel>?> getCategories() async {
    final response = await http.post(
      Uri.parse(categoriesUrl),
      headers: ApiUtils.getHeaders(),
    );
    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez accéder aux données dans response.body
      print(response.body);
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
