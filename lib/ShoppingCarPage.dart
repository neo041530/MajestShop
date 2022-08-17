import 'package:flutter/material.dart';

class ShoppingCarPage extends StatefulWidget {
  const ShoppingCarPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCarPage> createState() => _ShoppingCarPage();
}

class _ShoppingCarPage extends State<ShoppingCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child:Text('1')
          ),
          Expanded(
            flex: 1,
            child:Text('1')
          ),
        ],
      ),
    );
  }
}
