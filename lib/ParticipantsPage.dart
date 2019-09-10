import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParticipantsPage extends StatefulWidget {
  @override
  _ParticipantsPage createState() => new _ParticipantsPage();
}

class _ParticipantsPage extends State<ParticipantsPage> {
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  final ref = FirebaseDatabase.instance.reference().child('com_content/form');

  TextEditingController editingController = TextEditingController();

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


    Widget _buildParticipantCard(eventSnapVal) {
      var spaceName = eventSnapVal["nazvanie-ploshchadki"].toString();
      var title = eventSnapVal["title"].toString();
      var busn_way = eventSnapVal["napravlenie-biznesa"].toString();

      return Card(
        margin: EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(title),
          subtitle: Text(busn_way),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      );
    }


    print("HHHEEE");
    if (pickedEvent == null)
      return Center(child: CircularProgressIndicator());
    return StreamBuilder(
      stream: ref.orderByChild("meropriyatiya").equalTo(pickedEvent["id"].toString()).onValue,
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {
          DataSnapshot snapshot = snap.data.snapshot;
          var snapVal = snapshot.value;
          var asList = snapVal.keys.toList();
          print("PARICIPANTS!");
          print(asList);
          return snap.data.snapshot.value == null
              ? SizedBox()
              : Container(
                  child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {

                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: asList.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return _buildParticipantCard(snapVal[asList[index]]);
                                }
                          ),
                        )
                      ],
                  ),
              );

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }
}
