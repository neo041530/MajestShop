import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();

  Future signin () async =>
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: EmailController.text.trim(), password: PasswordController.text.trim()
    );

  @override
  void dispose(){
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Opacity(
          //   opacity: 0.3,
          //   child: Image.asset('assets/Back.jpeg',
          //     width: size.width,height: size.height,fit: BoxFit.fill,
          //   ),
          // ),
          // Positioned(
          //   left: 10,
          //   top: 50,
          //   child: IconButton(
          //     icon: Icon(Icons.arrow_back_ios),
          //     onPressed: (){
          //       Navigator.pop(context);
          //     },
          //   )
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(
                      'assets/logobackground.png',fit: BoxFit.fill,height: size.height*0.25,
                      color: Colors.black,
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                child: TextFormField(
                  controller: EmailController,
                  decoration: const InputDecoration(
                      label:  Text('Email',style: TextStyle(fontSize: 20),),
                      prefixIcon:  Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                child: TextFormField(
                  controller: PasswordController,
                  decoration: const InputDecoration(
                      label:  Text('Password',style: TextStyle(fontSize: 20),),
                      prefixIcon:  Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: GestureDetector(
                  child: const Text('忘記密碼',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      decoration: TextDecoration.underline
                    ),
                  ),
                  onTap: (){},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 15),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('登入',style: TextStyle(fontSize: 25),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: (){
                      signin();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 60),
                child: Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('用以下方式連接',style: TextStyle(fontSize: 20),)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.facebook,size: 35,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  FaIcon(
                    FontAwesomeIcons.google,size: 35,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  FaIcon(
                    FontAwesomeIcons.phone,size: 35,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('還沒有帳號?',style: TextStyle(fontSize: 20),),
                  const SizedBox(width: 10,),
                  GestureDetector(
                    child: const Text('註冊帳號',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.underline
                      ),
                    ),
                    onTap: (){},
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
