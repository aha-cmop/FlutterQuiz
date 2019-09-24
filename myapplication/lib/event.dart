import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'main.dart';
import './MapPage.dart';
import './TimeTablePage.dart';
import './ParticipantsPage.dart';
import './InfoPage.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {

  int _selectedTab = 3;

  final _pageOptions = [
    MapPage(),
    TimeTablePage(),
    ParticipantsPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

