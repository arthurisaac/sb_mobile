import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartbox/features/model/box_model.dart';
import 'package:http/http.dart' as http;
import 'package:smartbox/ui/boxes/box_details_screen.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

class BoxesInCategories extends StatefulWidget {
  final int category;
  final String title;
  const BoxesInCategories({Key? key, required this.category, required this.title}) : super(key: key);

  @override
  State<BoxesInCategories> createState() => _BoxesInCategoriesState();
}

class _BoxesInCategoriesState extends State<BoxesInCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(space),
          child: FutureBuilder<List<Box>?>(
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
                  return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: boxList.length,
                      itemBuilder: (context, index) {
                        Box box = boxList[index];
                        return BoxItem(box: box);
                      });
                } else {
                  return const Center(
                    child: Text("Nous n'avons aucun cadeau disponible pour cette catégorie"),
                  );
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

  Future<List<Box>?> getBoxes() async {
    final body = {
      categoryKey: widget.category.toString(),
    };
    final response = await http.post(
      Uri.parse(boxesInCategoryUrl),
      headers: ApiUtils.getHeaders(),
      body: body
    );
    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez accéder aux données dans response.body
      print(response.body);
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Box> list = jsonResponse.map((e) => Box.fromJson(e)).toList();

      return list;
    } else {
      // La requête a échoué avec un code d'erreur, comme 401 Unauthorized
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}

class BoxItem extends StatelessWidget {
  final Box box;
  const BoxItem({Key? key, required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BoxDetailsScreen(box: box)));
      },
      child: Card(
        elevation: 50,
        shadowColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 100,
                width: double.maxFinite,
                padding: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("$mediaUrl${box.image}"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
              ),
            ),
            spaceWidget,
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${box.name}"),
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
                  Text("${box.price} $priceSymbol", style: Theme.of(context).textTheme.labelSmall?.copyWith(wordSpacing: -2, color: Colors.blueGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
