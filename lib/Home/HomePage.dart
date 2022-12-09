import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:majestyshop/ProductPage.dart';
import 'package:majestyshop/SearchDonePage.dart';
import 'package:majestyshop/SeriesPage.dart';
import 'package:majestyshop/ShoppingCarPage.dart';

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

class TypeTitle{
  final List<dynamic> typeTitle;

  TypeTitle({required this.typeTitle});

  Map<String, dynamic> toJson() => {
    'Type' : Type
  };

  static TypeTitle fromJson(Map<String,dynamic> json) => TypeTitle(
      typeTitle : json['TypeTitle']
  );
}

class HotSearch{
  final int id;
  final String Name;
  final String Photo;

  HotSearch({required this.id,required this.Name,required this.Photo});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Name' : Name,
    'Photo' : Photo
  };

  static HotSearch fromJson(Map<String,dynamic> json) => HotSearch(
    id : json['id'],
    Name : json['Name'],
    Photo : json['Photo'],
  );
}

class NewSeries{
  final String Name;
  final String Photo;
  final String Series;
  final String Video;
  final List<dynamic> Type;

  NewSeries({required this.Name,required this.Photo,required this.Series,required this.Video,required this.Type});

  Map<String, dynamic> toJson() => {
    'Name' : Name,
    'Photo' : Photo,
    'Series' : Series,
    'Video': Video,
    'Type' : Type

  };

  static NewSeries fromJson(Map<String,dynamic> json) => NewSeries(
    Name : json['Name'],
    Photo : json['Photo'],
    Series :json['Series'],
    Video:json['Video'],
    Type :json['Type']
  );
}

class SearchHistory{
  final String Name;

  SearchHistory({required this.Name});

  Map<String, dynamic> toJson() => {
    'Name' : Name,
  };

  static SearchHistory fromJson(Map<String,dynamic> json) => SearchHistory(
    Name : json['Name'],
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  var Focus = FocusNode();
  var size;
  var TabBarIndex = [
    '系列',
    '全部'
  ];

  void initState(){
    Focus.addListener(() {//按了上面的搜尋欄會跳到SearchPage
      if(Focus.hasFocus) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const SearchPage()));
        Focus.unfocus();
      }
    });
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
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const ShoppingCarPage()
                        ));
                      },
                      icon: const Icon(Icons.shopping_cart)
                    ),
                  ],
                ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: TabBarIndex.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(e,style: Theme.of(context).textTheme.headline1),
                  )).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children : [
            TabOne(height: size.height,scrollController: _scrollController),
            TabTwo(width: size.width,scrollController: _scrollController)
          ]
        ),
      ),
    );
  }
}

class TabOne extends StatelessWidget {
  const TabOne({Key? key, required this.height, required this.scrollController}) : super(key: key);
  final double height;
  final ScrollController scrollController;
  Stream<List<Series>> ReadSeries() =>//讀取有哪些系列
  FirebaseFirestore.instance
      .collection('HomeSeries')
      .orderBy('id')
      .snapshots()
      .map((event) =>
      event.docs.map((e) =>
          Series.fromJson(e.data())
      ).toList()
  );

  @override
  Widget build(BuildContext context) {
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
                      controller: scrollController,
                      slivers: [
                        SliverOverlapInjector(handle:NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                        SliverFixedExtentList(
                          itemExtent: height*0.25,
                          delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                            return SeriesCard(Type: series[index].Type, Video: series[index].Video, Name: series[index].Name, Photo: series[index].Photo, height: height);
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
}

class TabTwo extends StatelessWidget {
  const TabTwo({Key? key, required this.width, required this.scrollController}) : super(key: key);
  final double width;
  final ScrollController scrollController;

  Stream<List<TypeTitle>> ReadAllProductTitle() =>//讀取全部商品頁裡的商品標頭
  FirebaseFirestore.instance
      .collection('TypeTitle').where('TypeTitleText',isEqualTo: 'AllProduct')
      .snapshots()
      .map((event) =>
      event.docs.map((e) =>
          TypeTitle.fromJson(e.data())
      ).toList()
  );

  Stream<List<SeriesProduct>> ReadAllProduct() =>//讀取全部商品
  FirebaseFirestore.instance
      .collection('Product')
      .snapshots()
      .map((event) =>
      event.docs.map((e) =>
          SeriesProduct.fromJson(e.data())
      ).toList()
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: StreamBuilder<List<TypeTitle>>(
          stream: ReadAllProductTitle(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              final error = snapshot.error;
              print(error.toString());
              return Text(error.toString());
            }else if(snapshot.hasData){
              List<TypeTitle> title= snapshot.data!;
              return CustomScrollView(
                  controller: scrollController,
                  slivers : [
                    SliverOverlapInjector(handle:NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                          return StreamBuilder<List<SeriesProduct>>(
                              stream: ReadAllProduct(),
                              builder: (context, snapshot) {
                                if(snapshot.hasError){
                                  final error = snapshot.error;
                                  print(error.toString());
                                  return Text(error.toString());
                                }else if(snapshot.hasData){
                                  List<SeriesProduct> product = snapshot.data!.where((element) => element.Type == title[0].typeTitle[index] ).toList();
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
                                          itemCount: product.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context, int index) {
                                            return ProductCard(id: product[index].id, Photo: product[index].Photo[0],
                                                Name: product[index].Name, Price: product[index].Price,
                                                Gender: product[index].Gender, width: width);
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
                  ]
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.id, required this.Photo, required this.Name,
    required this.Price, required this.Gender, required this.width}) : super(key: key);
  final int id;
  final String Photo;
  final String Name;
  final String Price;
  final String Gender;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width*0.55,
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
                    builder: (context) => ProductPage(id: id,))
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
                          image: NetworkImage(Photo),
                          height: 150,
                          width: width*0.5,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text(Name.replaceAll('\\n', '\n').split('\n')[0],
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.headline2
                                ),
                              ),
                              FittedBox(
                                child: Text(Name.replaceAll('\\n', '\n').split('\n')[1],
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.headline2
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: FittedBox(
                              child: Text('售價 : $Price',style:Theme.of(context).textTheme.headline2)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                              decoration: BoxDecoration(
                                  color: Gender == 'Mens' ? Colors.blueAccent:Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text(
                                  Gender,
                                  style: Theme.of(context).textTheme.headline3
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
  }
}

class SeriesCard extends StatelessWidget {
  const SeriesCard({Key? key, required this.Type, required this.Video, required this.Name, required this.Photo, required this.height}) : super(key: key);
  final List<dynamic> Type;
  final String Video;
  final String Name;
  final String Photo;
  final double height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                SeriesPage(Type:Type,Video: Video,
                    Name:Name)
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
                            child: Text('MAJESTY\n$Name',
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
                  child: Image.network(Photo),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var SearchFocus = FocusNode();
  var Date = DateTime.now();
  //TextEditingController Search = TextEditingController();

  Future AddHistory(SearchString) async {
    await FirebaseFirestore.instance.collection('SearchHistory')
        .doc('${FirebaseAuth.instance.currentUser?.email}$SearchString')
        .set({
      'Email' : FirebaseAuth.instance.currentUser?.email,
      'Name' : SearchString,
      'Time' : Date
    }).then((value) =>
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchDonePage(SearchString:SearchString))
        )
    ).onError((error, stackTrace) => null);
  }

  Stream<List<NewSeries>> ReadNewSeries() =>
      FirebaseFirestore.instance
          .collection('HotSeach').where('TypeTitle',isEqualTo: 'NewSeries')
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              NewSeries.fromJson(e.data())
          ).toList()
      );
  Stream<List<HotSearch>> ReadHotSearchProduct() =>
      FirebaseFirestore.instance
          .collection('HotSeach').where('Type',isEqualTo: 'HotSearch').orderBy('HotNumber')
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              HotSearch.fromJson(e.data())
          ).toList()
      );

  Stream<List<SearchHistory>> ReadSearchHistory(email) =>
      FirebaseFirestore.instance
          .collection('SearchHistory').where('Email',isEqualTo: email).orderBy('Time',descending: true)
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              SearchHistory.fromJson(e.data())
          ).toList()
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<List<NewSeries>>(
          stream: ReadNewSeries(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              final error = snapshot.error;
              print(error.toString());
              return Text(error.toString());
            }else if(snapshot.hasData){
              List<NewSeries> newseries = snapshot.data!;
              return CustomScrollView(
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
                            //controller: Search,
                            onSubmitted:(value){
                              if(value.isNotEmpty){
                                AddHistory(value);
                              }
                            },
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
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      SeriesPage(Type:newseries[0].Type,Video: newseries[0].Video,Name:newseries[0].Series ,)
                              ));
                            },
                            leading: Text(newseries[0].Name,style: Theme.of(context).textTheme.headline2),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Image.network(newseries[0].Photo),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        final error = snapshot.error;
                        print(error.toString());
                        return Text(error.toString());
                      }else if(snapshot.hasData){
                        final user = snapshot.data;
                        return StreamBuilder<List<SearchHistory>>(
                          stream: ReadSearchHistory(user!.email),
                          builder: (context, snapshot) {
                            if(snapshot.hasError){
                              final error = snapshot.error;
                              print(error.toString());
                              return Text(error.toString());
                            }else if(snapshot.hasData){
                              List<SearchHistory> search = snapshot.data!;
                              if(search.length>6){
                                search.removeRange( 6, search.length);
                              }
                              return SliverList(
                                  delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                                    return Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(color: Colors.grey)
                                          )
                                      ),
                                      child: ListTile(
                                          onTap: (){
                                            AddHistory(search[index].Name);
                                          },
                                          leading: Text(search[index].Name,
                                            style: Theme.of(context).textTheme.headline2
                                          )
                                      ),
                                    );
                                  },childCount: search.length)
                              );
                            }else{
                              return SliverList(
                                delegate: SliverChildListDelegate([]),
                              );
                            }

                          }
                        );
                      }else{
                        return SliverList(
                          delegate: SliverChildListDelegate([]),
                        );
                      }
                    }
                  ),
                  SliverList(
                    //itemExtent: size.height*0.25,
                    delegate: SliverChildListDelegate([
                      Container(
                        height: 10,
                        color: Colors.grey[350],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        child: Text('熱門搜尋',style: Theme.of(context).textTheme.headline2),
                      ),
                      StreamBuilder<List<HotSearch>>(
                          stream: ReadHotSearchProduct(),
                          builder: (context, snapshot) {
                            if(snapshot.hasError){
                              final error = snapshot.error;
                              print(error.toString());
                              return Text(error.toString());
                            }else if(snapshot.hasData){
                              List<HotSearch> hotsearch = snapshot.data!;
                              print(hotsearch.length);
                              return Wrap(
                                  children :  List.generate(hotsearch.length,(index)=>
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
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => ProductPage(id: hotsearch[index].id))
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: FittedBox(child: Text(hotsearch[index].Name.replaceAll('\\n', '\n'),style: Theme.of(context).textTheme.headline2,)),
                                                    )
                                                ),
                                                Expanded(
                                                    child: Image.network(hotsearch[index].Photo)
                                                ),
                                              ],
                                            ),
                                          )
                                      )
                                  ).toList()
                              );
                            }else{
                              return const Center(child: CircularProgressIndicator());
                            }
                          }
                      ),
                    ]),
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