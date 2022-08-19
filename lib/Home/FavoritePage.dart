import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:majestyshop/Home/HomePage.dart';
import 'package:majestyshop/LoginPage.dart';
import 'package:majestyshop/ProductPage.dart';

class FavoriteProduct{
  final int id;
  final String Name;
  final String Photo;
  final String Price;
  final String Type;
  final String Gender;

  FavoriteProduct({required this.id,required this.Name,required this.Photo,required this.Price,required this.Type,required this.Gender});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Name' : Name,
    'Photo' : Photo,
    'Video' : Price,
    'Type' : Type,
    'Gender' : Gender
  };

  static FavoriteProduct fromJson(Map<String,dynamic> json) => FavoriteProduct(
      id : json['id'],
      Name : json['Name'],
      Photo : json['Photo'],
      Price : json['Price'],
      Type : json['Type'],
      Gender : json['Gender']
  );
}

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  Stream<List<TypeTitle>> ReadFavoriteTitle() =>
      FirebaseFirestore.instance
          .collection('TypeTitle').where('TypeTitleText',isEqualTo:'FavoriteTitle')
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              TypeTitle.fromJson(e.data())
          ).toList()
      );

  Stream<List<FavoriteProduct>> ReadFavoriteProduct(email) =>
      FirebaseFirestore.instance
          .collection('FavoritePage').orderBy('Date',descending: true).where('Email',isEqualTo:email)
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              FavoriteProduct.fromJson(e.data())
          ).toList()
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: StreamBuilder<User?>(//抓使用者登入
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            final error = snapshot.error;
            print(error.toString());
            return Text(error.toString());
          }else if(snapshot.hasData){
            final user = snapshot.data;
            print(user!.email);
            return StreamBuilder<List<TypeTitle>>(
              stream: ReadFavoriteTitle(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  final error = snapshot.error;
                  print(error.toString());
                  return Text(error.toString());
                }else if(snapshot.hasData){
                  List<TypeTitle> title= snapshot.data!;
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.black,
                        pinned: true,
                        title: const Text('我的最愛'),
                        actions: [
                          IconButton(
                              onPressed:(){},
                              icon: const Icon(Icons.shopping_cart)
                          )
                        ],
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                            return StreamBuilder<List<FavoriteProduct>>(
                              stream: ReadFavoriteProduct(user.email!),
                              builder: (context, snapshot) {
                                if(snapshot.hasError){
                                  final error = snapshot.error;
                                  print(error.toString());
                                  return Text(error.toString());
                                }else if(snapshot.hasData){
                                  List<FavoriteProduct> favoriteproduct= snapshot.data!.where((element) => element.Type == title[0].typeTitle[index]).toList();
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(title[0].typeTitle[index],style:GoogleFonts.lato(fontSize: 30)),
                                      ),
                                      SizedBox(
                                        height: 300,
                                        child: ListView.builder(
                                          itemCount: favoriteproduct.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context, int i) {
                                            return SizedBox(
                                              width: size.width*0.55,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Card(
                                                    clipBehavior: Clip.antiAlias,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15)
                                                    ),
                                                    child: InkWell(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(
                                                            builder: (context) => ProductPage(id: favoriteproduct[i].id,))
                                                        );
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            flex: 5,
                                                            child: Stack(
                                                              alignment: Alignment.topRight,
                                                              children: [
                                                                Ink.image(
                                                                  image: NetworkImage(favoriteproduct[i].Photo),
                                                                  height: 150,
                                                                  width: size.width*0.5,
                                                                  fit: BoxFit.fitHeight,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: GestureDetector(
                                                                      onTap: (){},
                                                                      child: const Icon(Icons.favorite_border,color: Colors.red,)
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                  child: Text(favoriteproduct[i].Name.replaceAll('\\n', '\n'),
                                                                    textAlign: TextAlign.start,
                                                                    style: const TextStyle(fontSize: 20),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                  child: FittedBox(
                                                                      child: Text('售價 : ${favoriteproduct[i].Price}',style:const TextStyle(fontSize: 20)
                                                                      )
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                  child: Container(
                                                                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                                                                      decoration: BoxDecoration(
                                                                          color: favoriteproduct[i].Gender == 'Mens' ? Colors.blueAccent:Colors.pinkAccent,
                                                                          //border: Border.all(),
                                                                          borderRadius: BorderRadius.circular(10)
                                                                      ),
                                                                      child: Text(
                                                                          favoriteproduct[i].Gender,
                                                                          style: TextStyle(fontSize: 18,color: Colors.white)
                                                                      )
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 2,
                                      ),
                                    ],
                                  );
                                }else{
                                  return const Center(child: CircularProgressIndicator());
                                }
                              }
                            );
                          },childCount: title[0].typeTitle.length)
                      )
                    ],
                  );
                }else{
                  return const Center(child: CircularProgressIndicator());
                }
              }
            );
          }else{
            return LoginPage();
          }
        }
      ),
    );
  }
}
