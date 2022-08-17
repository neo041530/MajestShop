import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:majestyshop/ImageDetail.dart';

class Product{
  final int id;
  final String Name;
  final String Introduce;
  final List<dynamic> Photo;
  final List<dynamic> DetailTitle;
  final Map<String, dynamic> Detail;
  final String Price;

  Product({required this.id,required this.Name,required this.Introduce,required this.Photo,required this.DetailTitle,required this.Detail,required this.Price});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Name' : Name,
    'Introduce' : Introduce,
    'Photo' : Photo,
    'DetailTitle' : DetailTitle,
    'Detail' : Detail,
    'Price' : Price,
  };

  static Product fromJson(Map<String,dynamic> json) => Product(
      id : json['id'],
      Name : json['Name'],
      Introduce : json['Introduce'],
      Photo : json['Photo'],
      DetailTitle : json['DetailTitle'],
      Detail : json['Detail'],
      Price : json['Price']
  );
}

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int oneIndex = 0;
  int twoIndex = 0;
  double pageindex = 0;
  String ProductName = 'MAJESTY\nCONQUEST Driver';
  String ProductPrice = '建議售價 ＄10000\n網路價 ＄8000';
  PageController pageController = PageController();
  List<String> angle =['10.5','10','9.5'];
  List<String> hardness =['S','SR','R','R2','L'];
  Stream<List<Product>> ReadProduct() =>
      FirebaseFirestore.instance
          .collection('Product').where('id',isEqualTo: widget.id)
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              Product.fromJson(e.data())
          ).toList()
      );
  void ShowShoppingCart(height,List<Product> product){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return SizedBox(
              height: height,
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(child: Image.network(product[0].Photo[0],fit: BoxFit.cover,))
                          ),
                          Expanded(
                            flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product[0].Name,style: const TextStyle(fontSize: 20)),
                                  const SizedBox(height: 10),
                                  Text(product[0].Price,style: const TextStyle(fontSize: 20))
                                ],
                              )
                          ),
                        ],
                      )
                    ),
                  const Divider(
                      thickness: 1,
                    ),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: product[0].DetailTitle.length,
                      itemBuilder: (BuildContext context, int index) {
                        //int Index = 0;
                        String Title = product[0].DetailTitle[index];
                        List<dynamic> TitleDetail = product[0].Detail[Title];
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text('${Title} :',style: TextStyle(fontSize: 20),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Wrap(
                                  spacing: 15,
                                  children: List.generate(TitleDetail.length, (index) {
                                    return ChoiceChip(
                                      label: Text(TitleDetail[index],
                                        style:TextStyle(
                                          color: oneIndex == index ? Colors.white : Colors.black
                                        ),
                                      ),
                                      selectedColor: Colors.black,
                                      selected: oneIndex == index,
                                      onSelected: (v) {
                                        setState(() {
                                          oneIndex = index;
                                        });},
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text('數量 : ',style: TextStyle(fontSize: 20),),
                        IconButton(onPressed: (){}, icon: Icon(Icons.remove)),
                        Text('1',style: TextStyle(fontSize: 20),),
                        IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                      ],
                    ),
                  ),
                  const Divider(
                      thickness: 1,
                    ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15 ,horizontal: 15),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text('加入購物車',style: TextStyle(fontSize: 20),),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.black),
                            ),
                            onPressed: (){},
                          ),
                        ),
                      )
                    ),
                ],
              )
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: StreamBuilder<List<Product>>(
        stream: ReadProduct(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            final error = snapshot.error;
            print(error.toString());
            return Text(error.toString());
          }else if(snapshot.hasData){
            List<Product> product = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  flex: 9,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.black,
                        expandedHeight: size.height*0.25,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(seconds: 1),
                                  reverseTransitionDuration: const Duration(seconds: 1),
                                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                    final curvedAnimation = CurvedAnimation(
                                      parent: animation,
                                      curve: const Interval(0,0.5)
                                    );
                                    return FadeTransition(
                                      opacity: curvedAnimation,
                                      child: ImageDetail(index: pageindex,photo: product[0].Photo,)
                                    );
                                  }
                                )
                              );
                            },
                            child: PageView(
                              controller: pageController,
                              children: product[0].Photo.map((e) =>
                                Hero(
                                  tag: 'image$pageindex',
                                  child: Image.network(e)
                                )
                              ).toList(),
                              onPageChanged: (index){
                                setState(() {
                                  pageindex = index.toDouble();
                                });
                              },
                            ),
                          ),
                        ),
                        actions: [
                          IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.favorite_border)
                          ),
                          IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.shopping_cart)
                          )
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          DotsIndicator(
                            dotsCount: product[0].Photo.length,
                            position: pageindex,
                            onTap: (position){
                              setState(() {
                                pageindex = position;
                                pageController.animateToPage(
                                    position.toInt(),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease
                                );
                              });
                            },
                            decorator: const DotsDecorator(
                                activeColor: Colors.black,
                                color: Colors.white
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal:15),
                            child: Text(product[0].Name,
                                style: GoogleFonts.lato(fontSize: 30)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:15),
                            child: Text('售價 : ${product[0].Price}',
                                style: GoogleFonts.lato(fontSize: 26)
                            ),
                          ),
                          const Divider(
                            thickness: 5,
                          ),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                          String Title = product[0].DetailTitle[index];
                          List<dynamic> TitleDetail = product[0].Detail[Title];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text('${Title} :',style: TextStyle(fontSize: 26),),
                              ),
                              Wrap(
                                children: TitleDetail.map((e) =>
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                                    child: RawChip(
                                      label:Text(e,style: TextStyle(fontSize: 20),),
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    ),
                                  ),
                                ).toList(),
                              ),
                              const Divider(
                                thickness: 5,
                              ),
                            ],
                          );
                        },childCount: product[0].DetailTitle.length)
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text('商品詳情 :',style: TextStyle(fontSize: 26),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:10,horizontal: 15),
                            child: Text(product[0].Introduce.replaceAll('\\n', '\n\n'),
                              style: const TextStyle(fontSize: 20)
                            ),
                          ),
                          const Divider(
                            thickness: 5,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text('為你推薦',style: TextStyle(fontSize: 26)),
                          ),
                        ])
                      ),
                      SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 300
                        ),
                        delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                          return SizedBox(
                            width: size.width*0.5,
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
                                          builder: (context) => ProductPage(id: 1,))
                                      );
                                    } ,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      //mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Ink.image(
                                                image: const AssetImage('assets/drive.png'),
                                                height: 150,
                                                width: size.width*0.5,
                                                fit: BoxFit.cover,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: GestureDetector(
                                                    onTap: (){

                                                    },
                                                    child: const Icon(Icons.favorite_border)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text('CONQUEST Driver',style: TextStyle(fontSize: 20),),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text('售價 : 10000',style: TextStyle(fontSize: 20)),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          );
                        },childCount: 3),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Row(
                      children: [
                        Expanded(
                            child: ListTile(
                              leading: const Icon(Icons.add_shopping_cart,color: Colors.white,),
                              title: const Text('加入購物車',style: TextStyle(color: Colors.white),),
                              onTap: (){
                                ShowShoppingCart(size.height,product);
                              },
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            width: 1,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: ListTile(
                              leading: Icon(Icons.message,color: Colors.white,),
                              title: Text('聯絡客服',style: TextStyle(color: Colors.white),),
                            )
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
