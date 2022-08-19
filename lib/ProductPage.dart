import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:majestyshop/CustomerService.dart';
import 'package:majestyshop/ImageDetail.dart';

import 'SeriesPage.dart';

class Product{
  final int id;
  final String Name;
  final String Introduce;
  final List<dynamic> Photo;
  final List<dynamic> DetailTitle;
  final Map<String, dynamic> Detail;
  final String Price;
  final String Type;
  final String Gender;

  Product({required this.id,required this.Name,required this.Introduce,
    required this.Photo,required this.DetailTitle,required this.Detail,required this.Price,required this.Type,required this.Gender});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Name' : Name,
    'Introduce' : Introduce,
    'Photo' : Photo,
    'DetailTitle' : DetailTitle,
    'Detail' : Detail,
    'Price' : Price,
    'Type' : Type,
    'Gender' : Gender,
  };

  static Product fromJson(Map<String,dynamic> json) => Product(
      id : json['id'],
      Name : json['Name'],
      Introduce : json['Introduce'],
      Photo : json['Photo'],
      DetailTitle : json['DetailTitle'],
      Detail : json['Detail'],
      Price : json['Price'],
      Type : json['Type'],
      Gender : json['Gender'],
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
  double pageindex = 0;
  PageController pageController = PageController();
  bool Login = FirebaseAuth.instance.currentUser?.uid != null;
  bool Favorite = false;
  var Date = DateTime.now();

  Stream<List<Product>> ReadProduct() =>
      FirebaseFirestore.instance
          .collection('Product').where('id',isEqualTo: widget.id)
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              Product.fromJson(e.data())
          ).toList());

  Stream<List<SeriesProduct>> ReadRecommendProduct(Gender,Type) =>
      FirebaseFirestore.instance
          .collection('Product').where('Gender',isEqualTo: Gender).where('Type',isEqualTo: Type)
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              SeriesProduct.fromJson(e.data())
          ).toList());

  Future AddHistory(List<Product> product) async {
    await FirebaseFirestore.instance.collection('FavoritePage')
      .doc('B${FirebaseAuth.instance.currentUser?.email}${product[0].id}')//B是瀏覽F是最愛
      .set({
        'Email' : FirebaseAuth.instance.currentUser?.email,
        'Gender' : product[0].Gender,
        'Name' : product[0].Name,
        'Photo' : product[0].Photo[0],
        'Price' : product[0].Price,
        'Type' : '瀏覽紀錄',
        'id' : product[0].id,
        'Date' : Date
      });
  }

  Future AddFavorite(List<Product> product) async {
    await FirebaseFirestore.instance.collection('FavoritePage')
        .doc('F${FirebaseAuth.instance.currentUser?.email}${product[0].id}')//B是瀏覽F是最愛
        .set({
          'Email' : FirebaseAuth.instance.currentUser?.email,
          'Gender' : product[0].Gender,
          'Name' : product[0].Name,
          'Photo' : product[0].Photo[0],
          'Price' : product[0].Price,
          'Type' : '最愛商品',
          'id' : product[0].id,
          'Date' : Date
    });
  }

  void ShowFavoriteView(size){
    final snackBar = SnackBar(
      content: const Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     Future.delayed(Duration(seconds: 1),(){
    //       Navigator.pop(context);
    //     });
    //     return Scaffold(
    //       backgroundColor: Colors.transparent,
    //       body: Center(
    //         child: GestureDetector(
    //           onTap: (){
    //             Navigator.pop(context);
    //           },
    //           child: Container(
    //             width: size.width*0.7,
    //             height: size.height*0.15,
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.circular(15)
    //             ),
    //             child: Column(
    //               children: const[
    //                 Expanded(
    //                   child: Center(
    //                     child: Icon(Icons.check_circle_outline_outlined,size: 40,)
    //                   )
    //                 ),
    //                 Expanded(
    //                   child: Center(
    //                     child: FittedBox(
    //                       child: Text('已加入最愛商品!!',style: TextStyle(fontSize: 25))
    //                     )
    //                   )
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   }
    // );
  }

  void CheckLogin(List<Product> product){
    if(Login){
      AddHistory(product);
    }
  }

  void initState(){
    FirebaseFirestore.instance.collection('FavoritePage')
        .where('Email',isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('Type',isEqualTo: '最愛商品')
        .where('id',isEqualTo: widget.id).get()
        .then((QuerySnapshot querySnapshot){
          setState(() {
            if(querySnapshot.docs.isEmpty){//無最愛
              Favorite = false;
            }else{//有最愛
              Favorite = true;
            }
          });
        });
  }

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
                                      Text(product[0].Name.replaceAll('\\n', '\n'),style: const TextStyle(fontSize: 20)),
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
                                              });
                                            },
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
                            padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 10),
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
      body: StreamBuilder<List<Product>>(//抓商品
        stream: ReadProduct(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            final error = snapshot.error;
            print(error.toString());
            return Text(error.toString());
          }else if(snapshot.hasData){
            List<Product> product = snapshot.data!;
            CheckLogin(product);
            return StreamBuilder<List<SeriesProduct>>(//抓推薦商品
              stream: ReadRecommendProduct(product[0].Gender, product[0].Type),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  final error = snapshot.error;
                  print(error.toString());
                  return Text(error.toString());
                }else if(snapshot.hasData){
                  List<SeriesProduct> RecommendProduct = snapshot.data!.where((element) => element.id != product[0].id ).toList();
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
                                LikeButton(
                                  size: 30,
                                  isLiked: Favorite,
                                  onTap: (Favorite) async{
                                    if(Favorite){
                                      print('1');
                                    }else{
                                      ShowFavoriteView(size);
                                    }
                                    return !Favorite;
                                  },
                                ),
                                // Favorite ?IconButton(
                                //   icon: const Icon(Icons.favorite,color: Colors.red),
                                //   onPressed: () {
                                //   },
                                // ):IconButton(
                                //   icon: const Icon(Icons.favorite_border),
                                //   onPressed: (){
                                //     ShowFavoriteView(size,product);
                                //   },
                                // ),
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
                                  child: Text(product[0].Name.replaceAll('\\n', ' '),
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
                                                builder: (context) => ProductPage(id: RecommendProduct[index].id,))
                                            );
                                          } ,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Ink.image(
                                                      image: NetworkImage(RecommendProduct[index].Photo[0]),
                                                      height: 150,
                                                      width: size.width*0.5,
                                                      fit: BoxFit.fitHeight,
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
                                                flex: 4,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Text(RecommendProduct[index].Name.split('\\n')[0],
                                                        style: const TextStyle(fontSize: 20),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: FittedBox(
                                                        child: Text(RecommendProduct[index].Name.split('\\n')[1],
                                                          style: const TextStyle(fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: FittedBox(
                                                        child: Text('售價 : ${RecommendProduct[index].Price}',
                                                          style: const TextStyle(fontSize: 20),)
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                                                        decoration: BoxDecoration(
                                                          color: RecommendProduct[index].Gender == 'Mens' ? Colors.blueAccent:Colors.pinkAccent,
                                                          borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        child: Text(
                                                          RecommendProduct[index].Gender,
                                                          style: const TextStyle(fontSize: 18,color: Colors.white)
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
                              },childCount: RecommendProduct.length),
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
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => const CustomerService())
                                      );
                                    },
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
            );
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
