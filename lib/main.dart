import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import "login_page.dart";
import "event.dart";
import "home.dart";
import 'start_page.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

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

    Widget createPage() {
      if (picked == null)
        return Center(child: CircularProgressIndicator());
      return picked ? Event() : Start();

    }

    return MaterialApp(
      title: 'GO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFFC5C5C5),
          primaryColor: Color(0xFF0B7BC1),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: Builder( builder: (context) => createPage()),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Start(),
        '/event': (BuildContext context) => new Event(),
      },
    );
  }
}
