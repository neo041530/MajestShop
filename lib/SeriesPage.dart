import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:majestyshop/ProductPage.dart';
import 'package:video_player/video_player.dart';

class SeriesProduct{
  final int id;
  final String Name;
  final List<dynamic> Photo;
  final String Price;
  final String Type;
  final String Gender;

  SeriesProduct({required this.id,required this.Name,required this.Photo,required this.Price,required this.Type,required this.Gender});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Name' : Name,
    'Photo' : Photo,
    'Video' : Price,
    'Type' : Type,
    'Gender' : Gender
  };

  static SeriesProduct fromJson(Map<String,dynamic> json) => SeriesProduct(
      id : json['id'],
      Name : json['Name'],
      Photo : json['Photo'],
      Price : json['Price'],
      Type : json['Type'],
      Gender : json['Gender']
  );
}

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key, required this.Type, required this.Video, required this.Name}) : super(key: key);
  final List<dynamic> Type;
  final String Video;
  final String Name;

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  late VideoPlayerController controller;
  List<dynamic> Type = [];
  Stream<List<SeriesProduct>> ReadSeriesProduct() =>
      FirebaseFirestore.instance
          .collection('Product').where('Series',isEqualTo:widget.Name)
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              SeriesProduct.fromJson(e.data())
          ).toList()
      );
  void initState(){
    Type = widget.Type;
    //controller = VideoPlayerController.asset('assets/Conquest.mp4');
    controller = VideoPlayerController.network(widget.Video);
    controller.initialize().then((value){
      setState(() {});
    });
    controller.addListener(() {
      setState(() {});
    });
    controller.play();
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
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
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned(
                    top: 0,bottom: 0,left: 0,right: 0,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),
                  controller.value.isPlaying ? SizedBox():Positioned(
                    top: 0,bottom: 0,left: 0,right: 0,
                    child: IconButton(
                      icon: Icon(Icons.replay,color: Colors.white,size: 50),
                      onPressed: (){
                        controller.play();
                      },
                    )
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed:(){},
                  icon: const Icon(Icons.shopping_cart)
              )
            ],
          ),
          SliverFixedExtentList(
            itemExtent: size.height*0.1,
            delegate: SliverChildListDelegate([
              Center(child: Text(widget.Name,style: GoogleFonts.lato(fontSize: 30)))
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context,int index){
              return StreamBuilder<List<SeriesProduct>>(
                stream: ReadSeriesProduct(),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    final error = snapshot.error;
                    print(error.toString());
                    return Text(error.toString());
                  }else if(snapshot.hasData){
                    List<SeriesProduct> series = snapshot.data!.where((element) =>element.Type == Type[index] ).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(Type[index],style:GoogleFonts.lato(fontSize: 30)),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: series.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int i) {
                              return SizedBox(
                                width: size.width*0.55,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          controller.pause();
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) => ProductPage(id: series[i].id,))
                                          ).then((value) => controller.play());
                                          // Navigator.of(context).push(
                                          //   PageRouteBuilder(
                                          //     transitionDuration: const Duration(seconds: 1),
                                          //     reverseTransitionDuration: const Duration(seconds: 1),
                                          //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                          //       final curvedAnimation = CurvedAnimation(
                                          //         parent: animation,
                                          //         curve: const Interval(0,0.5)
                                          //       );
                                          //       return FadeTransition(
                                          //         opacity: curvedAnimation,
                                          //         child:ProductPage(id: series[i].id)
                                          //       );
                                          //     }
                                          //   )
                                          // ).then((value) => controller.play());
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
                                                    image: NetworkImage(series[i].Photo[0]),
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
                                                    child: Text(series[i].Name.replaceAll('\\n', '\n'),
                                                      textAlign: TextAlign.start,
                                                      style: const TextStyle(fontSize: 20),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: FittedBox(
                                                      child: Text('售價 : ${series[i].Price}',style:const TextStyle(fontSize: 20)
                                                      )
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                                                      decoration: BoxDecoration(
                                                        color: series[i].Gender == 'Mens' ? Colors.blueAccent:Colors.pinkAccent,
                                                        //border: Border.all(),
                                                        borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: Text(
                                                        series[i].Gender,
                                                        style: TextStyle(fontSize: 18,color: Colors.white)
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
            },childCount: Type.length)
          )
        ],
      ),
    );
  }
}
