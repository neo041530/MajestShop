import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:majestyshop/SeriesPage.dart';

class Series{
  final String id;
  final String Name;
  final String Photo;

  Series(this.id, this.Name, this.Photo);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Series> series = [];
  final ScrollController _scrollController = ScrollController();
  var TabBarIndex = [
    '球杆',
    '配件'
  ];
  void initState(){
    series = [Series('1', 'MAJESTY \n\nCONQUEST', 'assets/One.png'),Series('2', 'MAJESTY \n\nPRESTIGIO XII', 'assets/Test.png')];
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: TabBarIndex.length,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Colors.black,
                floating: false,
                pinned: true,
                title: Row(
                  children: [
                    Image.asset('assets/logo.jpg',width: 130),
                    const Expanded(
                      child: TextField(
                        //controller: search_text,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          hintText: '搜尋商品',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              color: Colors.white
                            )
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                                color: Colors.white
                            )
                          )
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed:(){},
                      icon: const Icon(Icons.shopping_cart)
                    )
                  ],
                ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: TabBarIndex.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(e,style: const TextStyle(fontSize: 20),),
                  )).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children : [
            TabOne(size.width,size.height),
            TabTwo()
          ]
        ),
      ),
    );
  }
  Widget TabOne(width,height){
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverOverlapInjector(handle:NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
              SliverFixedExtentList(
                itemExtent: height*0.25,
                delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                  return  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>const SeriesPage())
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 20),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: height*0.2,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container()
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(series[index].Name,
                                          style: GoogleFonts.lato(
                                            fontSize: 25,
                                          )
                                        )
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: -30,
                            //left: 30,
                            child: SizedBox(
                              height: height*0.25,
                              child: Image.asset(series[index].Photo)
                            )
                          ),
                        ],
                      ),
                    ),
                  );
                },childCount: series.length),
              ),
            ],
          );
        }
      ),
    );
  }
  Widget TabTwo(){
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(child: Text('2')),
    );
  }
}

