import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:majestyshop/ProductPage.dart';
import 'package:majestyshop/SeriesPage.dart';
class Series{
  final int id;
  final String Name;
  final String Photo;
  final String Video;
  final List<dynamic> Type;

  Series({required this.id,required this.Name,required this.Photo,required this.Video,required this.Type});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Name' : Name,
    'Photo' : Photo,
    'Video' : Video,
    'Type' : Type
  };

  static Series fromJson(Map<String,dynamic> json) => Series(
      id : json['id'],
      Name : json['Name'],
      Photo : json['Photo'],
      Video : json['Video'],
      Type : json['Type']
  );
}
class HotSearch{
  final String id;
  final String Name;
  final String Photo;

  HotSearch(this.id, this.Name, this.Photo);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HotSearch> hotsearch = [];
  List<String> searchhistory = ['Driver','7iron'];
  final ScrollController _scrollController = ScrollController();
  var Focus = FocusNode();
  var size;
  var SearchFocus = FocusNode();
  var TabBarIndex = [
    '系列',
    '全部'
  ];
  Stream<List<Series>> ReadSeries() =>
      FirebaseFirestore.instance
        .collection('HomeSeries')
        .orderBy('id')
        .snapshots()
        .map((event) =>
          event.docs.map((e) =>
            Series.fromJson(e.data())
          ).toList()
        );
  void initState(){
    hotsearch = [
      HotSearch('1', 'Driver', 'assets/drive.png'),
      HotSearch('2', '7icon', 'assets/ironback.png'),
      HotSearch('3', '3wood', 'assets/wood.png'),
      HotSearch('3', '3wood', 'assets/wood.png'),
      HotSearch('1', 'Driver', 'assets/drive.png'),
      HotSearch('2', '7icon', 'assets/ironback.png'),
    ];
    Focus.addListener(() {
      if(Focus.hasFocus) {
        Seach();
        Focus.unfocus();
      }
    });
  }
  void Seach(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          //backgroundColor: Colors.grey,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                pinned: true,
                title: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: SearchFocus,
                        autofocus: true,
                        //controller: search_text,
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.search),
                            hintText: '搜尋商品',
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
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey)
                      )
                    ),
                    child: Banner(
                      message: 'NEW',
                      location: BannerLocation.topEnd,
                      child: ListTile(
                        leading: Text('最新上市 PRESTIGIO XII',style: TextStyle(fontSize: 20),),
                        trailing: Image.asset('assets/Test.png'),
                      ),
                    ),
                  )
                ]),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey)
                      )
                    ),
                    child: ListTile(
                      leading: Text(searchhistory[index],
                        style: const TextStyle(fontSize: 20),
                      )
                    ),
                  );
                },childCount: searchhistory.length)
              ),
              SliverList(
                //itemExtent: size.height*0.25,
                delegate: SliverChildListDelegate([
                  Container(
                    height: 10,
                    color: Colors.grey[350],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                    child: Text('熱門搜尋',style: TextStyle(fontSize: 20),),
                  ),
                  Wrap(
                    children: List.generate(hotsearch.length, (index) =>
                      Container(
                        width: size.width*0.5,
                        height: size.height*0.1,
                        decoration: index == 0 || index ==2 || index ==4?BoxDecoration(
                          border: index ==4 ?const Border(
                            top: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ):const Border(
                            top: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                          ),
                        ): BoxDecoration(
                          border: index == 5 ? const Border(
                            top: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ):const Border(
                            top: BorderSide(color: Colors.grey),
                          )
                        ),
                        child: Center(
                          child: ListTile(
                            onTap: (){
                              print(index);
                            },
                            leading: Text(hotsearch[index].Name,style: TextStyle(fontSize: 20),),
                            trailing: Image.asset(hotsearch[index].Photo),
                          ),
                        ),
                      )
                    ).toList()
                  ),
                ]),
              )
            ],
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
                    Expanded(
                      child: TextField(
                        focusNode: Focus,
                        //controller: search_text,
                        decoration: const InputDecoration(
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
                      icon: Icon(Icons.shopping_cart)
                    ),
                    // Badge(
                    //   badgeContent: Text('4'),
                    //   child: IconButton(
                    //     onPressed:(){},
                    //     icon: Icon(Icons.shopping_cart)
                    //   ),
                    // )
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
            TabTwo(size.width,size.height)
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
          return StreamBuilder<List<Series>>(
            stream: ReadSeries(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                final error = snapshot.error;
                print(error.toString());
                return Text(error.toString());
              }else if(snapshot.hasData){
                List<Series> series = snapshot.data!;
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
                              builder: (context) =>
                                SeriesPage(Type:series[index].Type,Video: series[index].Video,Name:series[index].Name ,)
                            ));
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
                                              flex: 3,
                                              child: Container()
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('MAJESTY\n${series[index].Name}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 25,
                                                )
                                              ),
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
                                    child: Image.network(series[index].Photo),
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
              }else{
                return const Center(child: CircularProgressIndicator());
              }
            }
          );
        }
      ),
    );
  }
  Widget TabTwo(width,height){
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            controller: _scrollController,
            slivers : [
              SliverOverlapInjector(handle:NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
              SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('開球杆',style:GoogleFonts.lato(fontSize: 30)),
                        ),
                        SizedBox(
                          width: width*0.5,
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
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Ink.image(
                                            image: const AssetImage('assets/drive.png'),
                                            height: 150,
                                            width: width*0.5,
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('CONQUEST Driver',style: TextStyle(fontSize: 20),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('售價 : 10000',style: TextStyle(fontSize: 20)),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('木杆',style:GoogleFonts.lato(fontSize: 30)),
                        ),
                        SizedBox(
                          width: width*0.5,
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
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Ink.image(
                                            image: const AssetImage('assets/wood.png'),
                                            height: 150,
                                            width: width*0.5,
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('CONQUEST 3wood',style: TextStyle(fontSize: 20),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('售價 : 6000',style: TextStyle(fontSize: 20)),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('鐵杆',style:GoogleFonts.lato(fontSize: 30)),
                        ),
                        SizedBox(
                          width: width*0.5,
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
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Ink.image(
                                            image: const AssetImage('assets/ironback.png'),
                                            height: 150,
                                            width: width*0.5,
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('CONQUEST 7iron',style: TextStyle(fontSize: 20),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('售價 : 4000',style: TextStyle(fontSize: 20)),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    );
                  },childCount: 1)
              )
            ]
          );
        }
      ),
    );
  }
}

