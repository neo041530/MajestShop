import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'LoginPage.dart';

class ShoppingProduct{
  final int id;
  final int Number;
  final String Name;
  final String Photo;
  final int Price;
  final String Type;

  ShoppingProduct({required this.id,required this.Number,required this.Name,
    required this.Photo,required this.Price,required this.Type});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Number' : Number,
    'Name' : Name,
    'Photo' : Photo,
    'Price' : Price,
    'Type' : Type,
  };

  static ShoppingProduct fromJson(Map<String,dynamic> json) => ShoppingProduct(
    id : json['id'],
    Number : json['Number'],
    Name : json['Name'],
    Photo : json['Photo'],
    Price : json['Price'],
    Type : json['Type'],
  );
}

class ShoppingCarPage extends StatefulWidget {
  const ShoppingCarPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCarPage> createState() => _ShoppingCarPage();
}

class _ShoppingCarPage extends State<ShoppingCarPage> {
  bool allCheck = false;
  bool Check = false;
  final int _TotalPrice = 0;
  final key = GlobalKey<_ShoppingCarItemState>();

  Stream<List<ShoppingProduct>> ReadShoppingCar(email) =>
      FirebaseFirestore.instance
          .collection('ShoppingCar').where('Email',isEqualTo: email)
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              ShoppingProduct.fromJson(e.data())
          ).toList());

  void all(){
    print('123');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('購物車'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            final error = snapshot.error;
            print(error.toString());
            return Text(error.toString());
          }else if(snapshot.hasData){
            final user = snapshot.data;
            return StreamBuilder<List<ShoppingProduct>>(
              stream: ReadShoppingCar(user!.email),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  final error = snapshot.error;
                  print(error.toString());
                  return Text(error.toString());
                }else if(snapshot.hasData){
                  List<ShoppingProduct> shopping = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                          flex: 9,
                          child:ListView.builder(
                            itemCount: shopping.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ShoppingCarItem(shopping: shopping,index: index,height: size.height);
                            },
                          )
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                          flex: 1,
                          child:Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: allCheck,
                                        checkColor: Colors.white,
                                        activeColor: Colors.black,
                                        onChanged: (value){
                                          // final state = key.currentState!;
                                          // state.allCheck();
                                          setState(() {
                                            allCheck=value!;
                                          });
                                        }
                                    ),
                                    Text('商品全選',style: Theme.of(context).textTheme.headline2),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('總金額\n＄$_TotalPrice',textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline2),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                      color: Colors.black,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(child: Text('買單(1)',style: Theme.of(context).textTheme.headline1)),
                                        ],
                                      )
                                  )
                              )
                            ],
                          )
                      ),
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

class ShoppingCarItem extends StatefulWidget {
  const ShoppingCarItem({Key? key, required this.shopping, required this.index, required this.height}) : super(key: key);
  final List<ShoppingProduct> shopping;
  final int index;
  final double height;

  @override
  State<ShoppingCarItem> createState() => _ShoppingCarItemState();
}

class _ShoppingCarItemState extends State<ShoppingCarItem> {
  bool Check = false;
  int ?Number;

  void initState(){
    Number = widget.shopping[widget.index].Number;
  }
  void allCheck(){
    setState(() {
      Check=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey,width: 5)
        )
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              onPressed: (BuildContext context) {

              },
            ),
            SlidableAction(
              backgroundColor: const Color(0xFF00BFFF),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              onPressed: (BuildContext context) {

              },
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: Check,
              checkColor: Colors.white,
              activeColor: Colors.black,
              onChanged: (value){
                if(Check){//取消選取

                }else{//選取

                }
                setState(() {
                  Check=value!;
                });
              }
            ),
            Expanded(
                flex: 3,
                child: Image.network(widget.shopping[widget.index].Photo,height: widget.height*0.2)
            ),
            Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 3),
                      child: Text(widget.shopping[widget.index].Name, style: Theme.of(context).textTheme.headline2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.shopping[widget.index].Type,
                              style: Theme.of(context).textTheme.headline2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text('＄${widget.shopping[widget.index].Price}',style: Theme.of(context).textTheme.headline2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3,bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(Number! > 1){
                                  setState(() {
                                    Number = Number!- 1;
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
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(Number.toString(),style: Theme.of(context).textTheme.headline2),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  Number = Number!+ 1;
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
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
