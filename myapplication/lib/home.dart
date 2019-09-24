import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedTab = 0;

  final _pageOptions = [
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        title: Text("Выберите мероприятие"),
      ),
      body: _pageOptions[_selectedTab],
    );
  }
}

class HomePage extends StatelessWidget {
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  final ref = FirebaseDatabase.instance.reference().child('com_content/form');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Future<Null> pickEvent(eventData)  async  {
      final SharedPreferences prefs = await _sprefs;
      prefs.setBool('picked', true);
      print("TTTTTTTEEEEEEEESSSSSSTTTt");
      print(eventData.toString());
      await prefs.setString('event', jsonEncode(eventData));
      Navigator.of(context).pushReplacementNamed('/event');
    }

    Widget _buildEventCard(eventSnapVal, daysBefore) {
      var eventName = eventSnapVal["nazvanie-meropriyatiya"].toString();
      var theme = eventSnapVal["tematika-meropriyatiya"].toString();
      var address = eventSnapVal["adres"].toString();
      var spaceName = eventSnapVal["nazvanie-ploshchadki"].toString();
      var place = spaceName;
      var startTime = eventSnapVal["start-meropriyatiya"].toString();

      return Card(
          margin: EdgeInsets.all(8.0),
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.blueAccent,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(eventName),
                  subtitle: Text(theme),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    ),
                    Icon(Icons.place),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                    ),
                    Text(place),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    ),
                    Icon(Icons.timer),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                    ),
                    Text(startTime),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                    ),
                    Text("Дней до начала: $daysBefore", textAlign: TextAlign.start,),
                    FlatButton(
                      child: const Text('Подробнее'),
                      textColor: Color(0xFF0B7BC1),
                      onPressed: (daysBefore <= 3) ? () {pickEvent(eventSnapVal);} : null,
                    ),
                  ],
                ),
              ],
            ),
          )
      );


    }


    return StreamBuilder(
            stream: ref.orderByChild("vid-uchastiya").equalTo(null).onValue,
            builder: (BuildContext context, AsyncSnapshot snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {
                DataSnapshot snapshot = snap.data.snapshot;
                var snapVal = snapshot.value;
                var asList = snapVal.keys.toList();
                asList.sort((a, b) {
                  final startTimeA = snapVal[a]["start-meropriyatiya"].toString();
                  final startTimeB = snapVal[b]["start-meropriyatiya"].toString();
                  DateTime startDateA = DateTime.parse(startTimeA);
                  DateTime startDateB = DateTime.parse(startTimeB);
                  final days = startDateA.difference(startDateB).inDays;
                  print("DAYS!!! $days");
                  return days;
                });
                return snap.data.snapshot.value == null
                    ? SizedBox()
                    : Container(
                    child: ListView.builder(
                        itemCount: asList.length,
                        itemBuilder: (BuildContext ctxt, int index) {

                          final startTime = snapVal[asList[index]]["start-meropriyatiya"].toString();
                          DateTime startDate = DateTime.parse(startTime);
                          final dateNow = DateTime.now();
                          final daysBefore = startDate.difference(dateNow).inDays;

                          if (daysBefore < 0)
                            return Container();


                          return _buildEventCard(snapVal[asList[index]], daysBefore);
                        }
                    ),
                );

              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
    );

  }
}
