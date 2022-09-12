import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:majestyshop/Home/HomePage.dart';

import 'SeriesPage.dart';
import 'main.dart';

class SearchDonePage extends StatefulWidget {
  const SearchDonePage({Key? key, required this.SearchString}) : super(key: key);
  final String SearchString;

  @override
  State<SearchDonePage> createState() => _SearchDonePageState();
}

class _SearchDonePageState extends State<SearchDonePage> {
  var SearchFocus = FocusNode();
  TextEditingController Search = TextEditingController();
  String ?searchString;

  Future AddHistory(SearchString) async {
    var Date = DateTime.now();
    await FirebaseFirestore.instance.collection('SearchHistory')
        .doc('${FirebaseAuth.instance.currentUser?.email}$SearchString')
        .set({
      'Email' : FirebaseAuth.instance.currentUser?.email,
      'Name' : SearchString,
      'Time' : Date
    }).then((value) =>
        setState(() {
          searchString = SearchString;
        })
    ).onError((error, stackTrace) => null);
  }

  Stream<List<SeriesProduct>> ReadProduct() =>
      FirebaseFirestore.instance
          .collection('Product')
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              SeriesProduct.fromJson(e.data())
          ).toList());

  void initState(){
    searchString = widget.SearchString;
    Search = TextEditingController(text: widget.SearchString);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<List<SeriesProduct>>(
      stream: ReadProduct(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          final error = snapshot.error;
          print(error.toString());
          return Text(error.toString());
        }else if(snapshot.hasData){
          List<SeriesProduct> product = snapshot.data!.where((element) => element.Name.contains(searchString!)).toList();
          return Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              title:Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          const MyHomePage()), (Route<dynamic> route) => false);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: SearchFocus,
                      autofocus: true,
                      controller: Search,
                      onSubmitted: (value){
                        AddHistory(value);
                      },
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(color: Colors.white)
                          )
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_alt),
                    onPressed:(){},
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Wrap(
                children :List.generate(product.length,
                  (index) => SizedBox(
                    height: 300,
                    width: size.width*0.5,
                    child: ProductCard(id: product[index].id, Photo: product[index].Photo[0], Name: product[index].Name,
                        Price: product[index].Price, Gender: product[index].Gender, width:size.width),
                  )
                )
              ),
            )
          );
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
