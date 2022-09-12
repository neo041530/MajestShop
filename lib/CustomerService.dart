import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

class Message{
  final int Type;
  final String message;

  Message({required this.Type,required this.message});

  Map<String, dynamic> toJson() => {
    'Type' : Type,
    'Message' : message,
  };

  static Message fromJson(Map<String,dynamic> json) => Message(
    Type : json['Type'],
    message : json['Message'],
  );
}

class CustomerService extends StatefulWidget {
  const CustomerService({Key? key}) : super(key: key);

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {

  Stream<List<Message>> ReadMessage(email) =>
      FirebaseFirestore.instance
          .collection('CustomerService').where('Email',isEqualTo: email).orderBy('Time')
          .snapshots()
          .map((event) =>
          event.docs.map((e) =>
              Message.fromJson(e.data())
          ).toList());

  Widget GuestMessage(message){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        )
                    ),
                    child: Text(message,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headline2
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget CustomerMessage(message){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipOval(
                child: Image.asset('assets/logo.jpg'),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )
                    ),
                    child: Text(message,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headline2
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('客服服務'),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            final error = snapshot.error;
            print(error.toString());
            return Text(error.toString());
          }else if(snapshot.hasData) {
            final user = snapshot.data;
            return StreamBuilder<List<Message>>(
              stream: ReadMessage(user!.email),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  final error = snapshot.error;
                  print(error.toString());
                  return Text(error.toString());
                }else if(snapshot.hasData){
                  List<Message> message = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                          flex: 8,
                          child: ListView.builder(
                            itemCount: message.length,
                            itemBuilder: (BuildContext context, int index) {
                              if(message[index].Type == 0){
                                return GuestMessage(message[index].message);
                              }else{
                                return CustomerMessage(message[index].message);
                              }
                            },
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextField(
                                    //focusNode: Focus,
                                    //controller: search_text,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '輸入訊息',
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: IconButton(
                                    onPressed: (){},
                                    icon: const Icon(Icons.send,color: Colors.white,)
                                ),
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
