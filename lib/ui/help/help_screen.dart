import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../features/model/faq_model.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../utils/api_utils.dart';
import '../utils/constants.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
      ),
      body: FutureBuilder<List<FAQ>?>(
        future: getBoxes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            return Text("Une erreur s'est produite ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List<FAQ>? faqList = snapshot.data;
            if (snapshot.data != null && faqList!.isNotEmpty) {
              return ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text("${faqList[index].question}"), //header title
                    children: [
                      Container(
                        color: Colors.black12,
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        child: Html(
                          data: faqList[index].response,
                          style: {
                            "body": Style(
                              padding: HtmlPaddings.zero,
                              margin: Margins.zero,
                            ),
                          },
                        ),
                      )
                    ],
                  );
                },
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
      ),
    );
  }

  Future<List<FAQ>?> getBoxes() async {
    final body = {};
    final response = await http.post(Uri.parse(faqUrl),
        headers: ApiUtils.getHeaders(), body: body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<FAQ> list = jsonResponse.map((e) => FAQ.fromJson(e)).toList();

      return list;
    } else {
      return null;
    }
  }
}
