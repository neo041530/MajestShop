import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:majestyshop/LoginPage.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: size.height*0.25,
            pinned: true,
            title: const Text('會員專區'),
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>const LoginPage())
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                onPressed:(){} ,
                icon: Icon(Icons.shopping_cart)
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('聯絡客服',style: TextStyle(fontSize: 20),),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: (){},
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      ListTile(
                        title: const Text('優惠訊息傳送',style: TextStyle(fontSize: 20),),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: (){},
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      ListTile(
                        title: const Text('尋找經銷商',style: TextStyle(fontSize: 20),),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: (){},
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      ListTile(
                        title: const Text('問題反饋',style: TextStyle(fontSize: 20),),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: (){},
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      ListTile(
                        title: const Text('登出',style: TextStyle(fontSize: 20),),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: (){},
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: Container(
                  height: size.height*0.15,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 15),
                        child: Text('追蹤我們',style: TextStyle(fontSize: 20),),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){},
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.facebook,size: 50,color: Colors.blue,
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){},
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.instagram,size: 50,color: Colors.pinkAccent,
                                )
                              ),
                            )
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){},
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.line,size: 50,color: Colors.green,
                                )
                              ),
                            )
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){},
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.youtube,size: 50,color: Colors.red,
                                )
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(child: Text('版本 1.0.0',style: TextStyle(fontSize: 20,color: Colors.black),)),
              )
            ])
          )
        ],
      ),
    );
  }
}
