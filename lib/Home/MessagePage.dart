import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('通知'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.shopping_cart)
          )
        ],
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
