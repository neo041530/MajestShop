import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:majestyshop/Home/FavoritePage.dart';
import 'package:majestyshop/Home/HomePage.dart';
import 'package:majestyshop/Home/MessagePage.dart';
import 'package:majestyshop/Home/PersonPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false,
      home: MyHomePage())
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int BottomBarIndex = 0;
  final BottomBarPage = [
    HomePage(),
    FavoritePage(),
    MessagePage(),
    PersonPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: BottomBarIndex == 0 ? null :AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      //   title: BottomBarIndex == 1 ? Text('Favorite',):
      //   BottomBarIndex == 2 ? Text('Message',):
      //   BottomBarIndex == 3 ? Text('Person',): null,
      // ),
      body:BottomBarPage[BottomBarIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.black,
        items: const [
          TabItem(icon: Icons.home, title: '首頁'),
          TabItem(icon: Icons.favorite, title: '最愛'),
          TabItem(icon: Icons.message, title: '通知'),
          TabItem(icon: Icons.person, title: '我的'),
        ],
        onTap: (index){
          setState(() {
            BottomBarIndex = index;
          });
        },
      )
    );
  }
}
