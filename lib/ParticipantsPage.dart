import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

class ParticipantsPage extends StatefulWidget {
  @override
  _ParticipantsPage createState() => new _ParticipantsPage();
}

class _ParticipantsPage extends State<ParticipantsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ref = FirebaseDatabase.instance.reference().child('com_content/form');
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  TextEditingController editingController = TextEditingController();

  PersistentBottomSheetController _sheetController;

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

    void partInfoSheet(eventSnapVal) {
      _sheetController = _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: Padding(
            padding: EdgeInsets.only(
                top: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0)),
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 10,
                            top: 10,
                            child: IconButton(
                              onPressed: () {
                              Navigator.of(context).pop();
                              },
                              icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      height: 50,
                      width: 50,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                            child: Text(
                              eventSnapVal["title"],
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
                            eventSnapVal["napravlenie-biznesa"],
                            style: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.pink,
                                fontFamily: 'Montserrat'),
                          ),
                          Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.all(8.0),
                            child: Html(
                              data: eventSnapVal["introtext"],
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height / 1.1,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                ),
              ),
          ),
        );
      });
    }


    Widget _buildParticipantCard(eventSnapVal) {
      var spaceName = eventSnapVal["nazvanie-ploshchadki"].toString();
      var title = eventSnapVal["title"].toString();
      var busn_way = eventSnapVal["napravlenie-biznesa"].toString();

      return GestureDetector(
        onTap: () {
          partInfoSheet(eventSnapVal);
        },
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(title),
            subtitle: Text(busn_way),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        )
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
              : Scaffold(
                  resizeToAvoidBottomPadding: false,
                  key: _scaffoldKey,
                  body: Container(
                    child: Column(
                        children: <Widget>[
                          AppBar(
                            elevation: 0.0,
                            title: Text("Участники"),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.exit_to_app),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed('/home');
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                  )
                );

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }
}
