import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smartbox/ui/utils/constants.dart';

class AdDetailsScreen extends StatefulWidget {
  final String ad;
  const AdDetailsScreen({Key? key, required this.ad}) : super(key: key);

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: SingleChildScrollView(child: Html(data: widget.ad)),
      ),
    );
  }
}
