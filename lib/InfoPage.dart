import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';


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
    if (pickedEvent == null)
      return Center(child: CircularProgressIndicator());
    return Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Color(0xFF0B7BC1).withOpacity(0.8)),
            clipper: getClipper(),
          ),
          Positioned(
              width: 350.0,
              top: MediaQuery.of(context).size.height / 10,
              bottom: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                    child: Text(
                      pickedEvent["nazvanie-meropriyatiya"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    pickedEvent["tematika-meropriyatiya"],
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.pink,
                        fontFamily: 'Montserrat'),
                  ),
                ],
              )
          ),
          Positioned(
              width: 350.0,
              top: MediaQuery.of(context).size.height / 3.65,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.all(8.0),
                    child: Html(
                      data: pickedEvent["introtext"],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.6,
                    height: 2.0,
                    color: Colors.black54,
                    margin: EdgeInsets.only(top: 4.0),
                  ),
                  Card(
                    child: ListTile(
                      leading: Container(
                        width: 40, // can be whatever value you want
                        alignment: Alignment.center,
                        child: Icon(Icons.assignment_ind),
                      ),
                      title: Text('Организатор'),
                      subtitle: Text(pickedEvent["organizator"]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("EEEEEEEEEEEEE");
                      launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                    },
                    child: Card(
                      child: ListTile(
                        leading: Container(
                          width: 40, // can be whatever value you want
                          alignment: Alignment.center,
                          child: Icon(Icons.web),
                        ),
                        title: Text('Сайт'),
                      ),
                    ),
                  ),
                ],
              )
          ),
          ////
    ]
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 3.65);
    path.lineTo(size.width * 4.25, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
