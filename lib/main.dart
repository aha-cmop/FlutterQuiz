import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import "login_page.dart";
import "event.dart";
import "home.dart";

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  bool picked;

  Future<Null> getData() async {
    final SharedPreferences prefs = await _sprefs;
    bool data = prefs.getBool('picked') ?? false;
    this.setState(() {
      picked = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'GO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFFC5C5C5),
          primaryColor: Color(0xFF0B7BC1),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (picked)
              return Event();
            return Home();
          }
          return LoginRegister();
        },
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/event': (BuildContext context) => new Event(),
        '/login': (BuildContext context) => new LoginRegister()
      },
    );
  }
}
