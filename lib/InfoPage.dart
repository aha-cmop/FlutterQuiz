import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => new _InfoPageState();
}
class _InfoPageState extends State<InfoPage> {

  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  var pickedEvent;

  Future<Null> getData() async {
    final SharedPreferences prefs = await _sprefs;
    var rawData = prefs.getString('event');
    print("RRAAAAWWWWW!");
    print(rawData);
    var data = jsonDecode(rawData);

    this.setState(() {
      pickedEvent = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Text(pickedEvent.toString());
  }
}
