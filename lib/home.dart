import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'main.dart';
import './MapPage.dart';
import './TimeTablePage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedTab = 0;

  final _pageOptions = [
    MapPage(),
    TimeTablePage(),
    HomePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        actions: <Widget>[],
//        elevation: 0.0,
//        title: Text("HOME"),
//      ),
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedTab,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedTab = index;
        }),

          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.map),
              title: Text("Карта")
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.access_time),
                title: Text("Расписание"),
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.assignment_ind),
                title: Text("Участники")
            ), BottomNavyBarItem(
                icon: Icon(Icons.info_outline),
                title: Text("О событии")
            ),
          ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (BuildContext context, AsyncSnapshot user) {
                if (user.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Welcome ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        user.data.displayName.toString() + "!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                        ),
                      )
                    ],
                  );
                }
              },
            ),
            FlatButton(
              splashColor: Colors.white,
              highlightColor: Theme.of(context).hintColor,
              child: Text(
                "Logout",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                auth.signOut().then((onValue) {
                  Navigator.of(context).pushReplacementNamed('/login');
                });
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );
  }
}
