import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/features/model/favorite_model.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/model/box_model.dart';
import '../helper/please_login_screen.dart';
import '../home/boxes_in_categories_screen.dart';
import '../utils/api_body_parameters.dart';
import '../utils/api_utils.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class FavoritesBoxesScreen extends StatefulWidget {
  const FavoritesBoxesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesBoxesScreen> createState() => _FavoritesBoxesScreenState();
}

class _FavoritesBoxesScreenState extends State<FavoritesBoxesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text("Liste de souhaits"),
            ),
            body:  context.read<AuthCubit>().state is Authenticated
            ? FutureBuilder<List<Favorite>?>(
              future: getFavorite(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Favorite>? list = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(space),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 24,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: list?.length,
                        itemBuilder: (context, index) {
                          Favorite favorite = list![index];
                          if (favorite.box == null) {
                            return const Card(
                              elevation: 50,
                              shadowColor: Colors.black,
                              child: Center(
                                child: Text("Ce item n'existe plus"),
                              ),
                            );
                          } else {
                            return BoxItem(box: favorite.box ?? Box());
                          }
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
            ) : const PleaseLoginScreen()
    );
  }

  Future<List<Favorite>?> getFavorite() async {
    final body = {userKey: context.read<AuthCubit>().getId().toString()};
    final response = await http.post(Uri.parse(favoritesdUrl),
        headers: ApiUtils.getHeaders(), body: body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Favorite> list =
          jsonResponse.map((e) => Favorite.fromJson(e)).toList();

      return list;
    } else {
      return null;
    }
  }
}