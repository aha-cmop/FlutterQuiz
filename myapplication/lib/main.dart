import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import "event.dart";
import 'home.dart';

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
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

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
    firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> msg) {
          print("onLaunch called");
        },
        onResume: (Map<String, dynamic> msg) {
          print("onResume called");
        },
        onMessage: (Map<String, dynamic> msg) {
          print("onMessage called");
        }
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true,
            alert: true,
            badge: true
        )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings){
      print('IOS setting registred');
    });
    firebaseMessaging.getToken().then((token){
      update(token);
    });
  }

  update(String token) {
    print("TOKEN: $token");
    setState(() {

    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Widget createPage() {
      if (picked == null)
        return Center(child: CircularProgressIndicator());
      return picked ? Event() : Home();

    }

    return MaterialApp(
      title: 'Посетитель',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFFC5C5C5),
          primaryColor: Color(0xFF0B7BC1),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: Builder( builder: (context) => createPage()),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/event': (BuildContext context) => new Event(),
      },
    );
  }
}
