import 'package:flutter/material.dart';
import 'package:smartbox/features/model/sub_category_item_model.dart';

import '../../features/model/box_model.dart';
import '../home/boxes_in_categories_screen.dart';
import '../utils/constants.dart';

class SubCategoriesItemsScreen extends StatefulWidget {
  final List<SubCategoryItemModel>? subCats;
  final String title;

  const SubCategoriesItemsScreen({Key? key, required this.subCats, required this.title}) : super(key: key);

  @override
  State<SubCategoriesItemsScreen> createState() => _SubCategoriesItemsScreenState();
}

class _SubCategoriesItemsScreenState extends State<SubCategoriesItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: GridView.builder(
            /* gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                ),*/
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 10,
              // width / height: fixed for *all* items
              childAspectRatio: 0.75,
            ),
            shrinkWrap: true,
            itemCount: widget.subCats!.length,
            itemBuilder: (context, index) {
              Box? box = widget.subCats![index].box;
              if (box != null) {
                return BoxItem(box: box);
              } else {
                return const Center(
                  child: Text("Box introuvable"),
                );
              }
            }),
      ),
    );
  }
}
