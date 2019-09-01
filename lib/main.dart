import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import "login_page.dart";

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'GO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFFD81B60),
          primaryColor: Color(0xFF0B7BC1),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
//            return Home();
          }
          return LoginRegister();
        },
      ),
      routes: <String, WidgetBuilder>{
//        '/home': (BuildContext context) => new Home(),
        '/login': (BuildContext context) => new LoginRegister()
      },
    );
  }
}
