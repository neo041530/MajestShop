import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:majestyshop/CustomerService.dart';
import 'package:majestyshop/Home/HomePage.dart';
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
    required this.Photo,required this.DetailTitle,required this.Detail,required this.Price,
    required this.Type,required this.Gender});

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

  Future AddFavorite(List<Product> product,size,BuildContext context) async {
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
    }).then((value) =>
      ShowFavoriteView(size,context)
    ).onError((error, stackTrace) => null);
  }

  Future DeleteFavorite(List<Product> product ) async {
    await FirebaseFirestore.instance.collection('FavoritePage')
        .doc('F${FirebaseAuth.instance.currentUser?.email}${product[0].id}')//B是瀏覽F是最愛
        .delete();
  }

  void ShowFavoriteView(size,BuildContext context){
    const snackBar = SnackBar(
      content: Text('已加入最愛商品!!'),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  void ShowShoppingCar(height,List<Product> product){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return addShoppingCar(height: height,product: product);
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
                                  isLiked: Favorite? true: false,
                                  onTap: (Favorite) async{
                                    if(Favorite){
                                      DeleteFavorite(product);
                                    }else{
                                      AddFavorite(product,size,context);
                                    }
                                    return !Favorite;
                                  },
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
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Text('$Title :',style: Theme.of(context).textTheme.headline4,),
                                      ),
                                      Wrap(
                                        children: TitleDetail.map((e) =>
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                                              child: RawChip(
                                                label:Text(e,style: Theme.of(context).textTheme.headline2),
                                                backgroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text('商品詳情 :',style: Theme.of(context).textTheme.headline4),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical:10,horizontal: 15),
                                    child: Text(product[0].Introduce.replaceAll('\\n', '\n\n'),
                                        style: Theme.of(context).textTheme.headline2
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text('為你推薦',style:  Theme.of(context).textTheme.headline4),
                                  ),
                                ])
                            ),
                            SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 300
                              ),
                              delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                                return ProductCard(id: RecommendProduct[index].id, Photo: RecommendProduct[index].Photo[0], Name: RecommendProduct[index].Name,
                                    Price: RecommendProduct[index].Price, Gender: RecommendProduct[index].Gender, width: size.width);
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
                                      ShowShoppingCar(size.height,product);
                                      //addShoppingCar();
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
                                    leading: const Icon(Icons.message,color: Colors.white,),
                                    title: const Text('聯絡客服',style: TextStyle(color: Colors.white),),
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

class addShoppingCar extends StatefulWidget {
  const addShoppingCar({Key? key, required this.height, required this.product}) : super(key: key);
  final double height;
  final List<Product> product;

  @override
  State<addShoppingCar> createState() => _addShoppingCarState();
}

class _addShoppingCarState extends State<addShoppingCar> {
  int oneIndex = 0;
  int Number = 1;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SizedBox(
            height: widget.height,
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Center(child: Image.network(widget.product[0].Photo[0],fit: BoxFit.cover,))
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.product[0].Name.replaceAll('\\n', '\n'),style: Theme.of(context).textTheme.headline2),
                                const SizedBox(height: 10),
                                Text(widget.product[0].Price,style: Theme.of(context).textTheme.headline2)
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
                    itemCount: widget.product[0].DetailTitle.length,
                    itemBuilder: (BuildContext context, int index) {
                      String Title = widget.product[0].DetailTitle[index];
                      List<dynamic> TitleDetail = widget.product[0].Detail[Title];
                      return ChoiceChipList(Title: Title, Length: TitleDetail.length, TitleDetail: TitleDetail);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text('數量 : ',style: Theme.of(context).textTheme.headline2),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          //padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if(Number > 1){
                                    setState(() {
                                      Number--;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide()
                                    )
                                  ),
                                  child: const Icon(Icons.remove)
                                ),
                              ),
                              Padding(
                                padding:  const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(Number.toString(),style: Theme.of(context).textTheme.headline2),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    Number++;
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide()
                                    )
                                  ),
                                  child: const Icon(Icons.add)
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15 ,right: 15,top: 10,bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('加入購物車',style: Theme.of(context).textTheme.headline1),
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
}
class ChoiceChipList extends StatefulWidget {
  const ChoiceChipList({Key? key, required this.Title, required this.Length, required this.TitleDetail}) : super(key: key);
  final String Title;
  final int Length;
  final List<dynamic> TitleDetail;

  @override
  State<ChoiceChipList> createState() => _ChoiceChipListState();
}

class _ChoiceChipListState extends State<ChoiceChipList> {
  int oneIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('${widget.Title} :',style: Theme.of(context).textTheme.headline2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 15,
                children: List.generate(widget.Length, (index) {
                  return ChoiceChip(
                    label: Text(widget.TitleDetail[index],
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
  }
}


