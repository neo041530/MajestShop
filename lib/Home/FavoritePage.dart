import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:majestyshop/ProductPage.dart';
class FavoriteList{
  final String id;
  final String Type;
  final String Name;
  final String Pay;
  final String Photo;

  FavoriteList(this.id,this.Type, this.Name, this.Pay, this.Photo);

}

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> Title =['最愛商品','瀏覽紀錄','為你推薦'];
  List<FavoriteList> Favorite =[];
  void initState(){
    Favorite = [
      FavoriteList('1','最愛商品','CONQUEST Driver','10000','assets/drive.png'),
      FavoriteList('2','最愛商品','CONQUEST 7Iron','4000','assets/ironback.png'),
      FavoriteList('3','最愛商品','CONQUEST 3Wood','8000','assets/wood.png'),
      FavoriteList('1','瀏覽紀錄','CONQUEST Driver','10000','assets/drive.png'),
      FavoriteList('3','瀏覽紀錄','CONQUEST 3Wood','8000','assets/wood.png'),
      FavoriteList('2','瀏覽紀錄','CONQUEST 7Iron','4000','assets/ironback.png'),
      FavoriteList('1','為你推薦','CONQUEST Driver','10000','assets/drive.png'),
      FavoriteList('2','為你推薦','CONQUEST 7Iron','4000','assets/ironback.png'),
      FavoriteList('3','為你推薦','CONQUEST 3Wood','8000','assets/wood.png'),
    ];
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
            pinned: true,
            title: const Text('我的最愛'),
            actions: [
              IconButton(
                  onPressed:(){},
                  icon: const Icon(Icons.shopping_cart)
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context,int index){
              List<FavoriteList> favorite = Favorite.where((element) => element.Type == Title[index]).toList();
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(Title[index],style:GoogleFonts.lato(fontSize: 30)),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: favorite.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int i) {
                        return SizedBox(
                          width: size.width*0.6,
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
                                            image: AssetImage(favorite[i].Photo),
                                            height: 150,
                                            width: size.width*0.5,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: GestureDetector(
                                              onTap: (){},
                                                child: const Icon(Icons.favorite,color: Colors.red,)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(favorite[i].Name,style: TextStyle(fontSize: 20),),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('售價 : '+favorite[i].Pay,style: TextStyle(fontSize: 20)),
                                      ),
                                    )
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
            },childCount: Title.length)
          )
        ],
      ),
    );
  }
}
