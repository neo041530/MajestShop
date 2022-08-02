import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  double pageindex = 0;
  PageController pageController = PageController(
      viewportFraction: 0.9,
      keepPage: true
  );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
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
                    background: PageView(
                      controller: pageController,
                      onPageChanged: (index){
                        setState(() {
                          pageindex = index.toDouble();
                        });
                      },
                      children: [
                        Image.asset('assets/iron.png'),
                        Image.asset('assets/drive.jpeg')
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.favorite_border)
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.shopping_cart)
                    )
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    DotsIndicator(
                      dotsCount: 2,
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
                      child: Text('MAJESTY\nCONQUEST Driver',
                        style: GoogleFonts.lato(fontSize: 30)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15),
                      child: Text('建議售價 ＄10000\n網路價 ＄8000',
                          style: GoogleFonts.lato(fontSize: 26)
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('角度 :',style: TextStyle(fontSize: 26),),
                    ),
                    Row(
                      children: const[
                         Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                          child: RawChip(
                            label:Text('10.5',style: TextStyle(fontSize: 20),),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                          child: RawChip(
                            label:Text('10',style: TextStyle(fontSize: 20),),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                          child: RawChip(
                            label:Text('9.5',style: TextStyle(fontSize: 20),),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('硬度 :',style: TextStyle(fontSize: 26),),
                    ),
                    Row(
                      children: const[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                          child: RawChip(
                            label:Text('S',style: TextStyle(fontSize: 20),),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                          child: RawChip(
                            label:Text('SR',style: TextStyle(fontSize: 20),),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                          child: RawChip(
                            label:Text('R',style: TextStyle(fontSize: 20),),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                  ]),
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
                      leading: Icon(Icons.add_shopping_cart,color: Colors.white,),
                      title: Text('加入購物車',style: TextStyle(color: Colors.white),),
                    )
                  ),
                  Expanded(child: Text('2')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
