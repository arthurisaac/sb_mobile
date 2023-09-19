import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';
import '../home/boxes_in_categories_screen.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          keyboardType: TextInputType.text,
          showCursor: true,
          readOnly: false,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Tapez pour recherchez un coffret",
          ),
          onTap: () {},
          onChanged: (text) {
            //print('First text field: $text');
            if (text.isNotEmpty && text.length > 2) {
              setState(() {});
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {});
          });
        },
        child: searchController.text.isEmpty ? Container() : FutureBuilder<List<Box>?>(
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
                    spaceWidget,
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.all(space),
                      child: const Text("Cadeaux"),
                    ),
                    spaceWidget,
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 24,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: boxList.length,
                          itemBuilder: (context, index) {
                            Box box = boxList[index];
                            return BoxItem(box: box);
                          }),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 120,),
                      spaceWidget,
                      Text("Aucun résultat pour cette recherche"),
                    ],
                  ),
                );
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

  Future<List<Box>?> getBoxes() async {
    final body = {
      userKey: context.read<AuthCubit>().getId().toString(),
      searchKey: searchController.text
    };
    final response = await http.post(Uri.parse(searchBoxUrl),
        headers: ApiUtils.getHeaders(), body: body);
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
