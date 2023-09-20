import 'package:flutter/material.dart';

class OrderNowScreen extends StatefulWidget {
  const OrderNowScreen({Key? key}) : super(key: key);

  @override
  State<OrderNowScreen> createState() => _OrderNowScreenState();
}

class _OrderNowScreenState extends State<OrderNowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mode de livraison"),
      ),
    );
  }
}
