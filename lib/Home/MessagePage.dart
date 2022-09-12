import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notice{
  final String NoticeText;
  final String Photo;
  final String Date;
  final String Url;

  Notice({required this.NoticeText, required this.Photo, required this.Date, required this.Url});

  Map<String, dynamic> toJson() => {
    'NoticeText' : NoticeText,
    'Photo' : Photo,
    'Date' : Date,
    'Url' : Url,
  };

  static Notice fromJson(Map<String,dynamic> json) => Notice(
    NoticeText : json['NoticeText'],
    Photo : json['Photo'],
    Date : json['Date'],
    Url : json['Url'],
  );
}

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  Stream<List<Notice>> ReadNotice() =>
      FirebaseFirestore.instance
          .collection('Notice').orderBy('Date')
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              Notice.fromJson(e.data())
          ).toList());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('通知'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.shopping_cart)
          )
        ],
      ),
      body: StreamBuilder<List<Notice>>(
        stream: ReadNotice(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            final error = snapshot.error;
            print(error.toString());
            return Text(error.toString());
          }else if(snapshot.hasData){
            List<Notice> notice = snapshot.data!;
            return ListView.builder(
              itemCount: notice.length,
              itemBuilder: (BuildContext context, int index) {
                return MessageCard(height: size.height, NoticeText: notice[index].NoticeText,
                    Photo: notice[index].Photo, Date: notice[index].Date, Url: notice[index].Url);
              }
            );
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}
class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.height, required this.NoticeText, required this.Photo, required this.Date, required this.Url}) : super(key: key);
  final double height;
  final String NoticeText;
  final String Photo;
  final String Date;
  final String Url;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.white,
        height: widget.height*0.15,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(widget.Photo),
              )
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10,top: 20),
                      child: Text(
                        widget.NoticeText,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(widget.Date),
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

