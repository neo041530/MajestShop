import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';


class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  late VideoPlayerController controller;
  void initState(){
    controller = VideoPlayerController.asset('assets/Conquest.mp4');
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
              Center(child: Text('CONQUEST 2022',style: GoogleFonts.lato(fontSize: 30)))
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context,int index){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('   開球杆',style:GoogleFonts.lato(fontSize: 30)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
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
                            Text('  Driver',style: TextStyle(fontSize: 20),),
                            Text('  售價 : 10000',style: TextStyle(fontSize: 20))
                          ],
                        ),
                      )
                    ),
                  )
                ],
              );
            },childCount: 1)
          )
        ],
      ),
    );
  }
}
