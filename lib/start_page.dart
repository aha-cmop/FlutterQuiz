import 'package:flutter/material.dart';

import './home.dart';
import './jobs.dart';


import 'package:bmnav/bmnav.dart' as bmnav;


class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {

  int _selectedTab = 0;

  final _pageOptions = [
    Home(),
    Jobs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: bmnav.BottomNav(
        index: _selectedTab,
        onTap: (i) {
          setState(() {
            _selectedTab = i;
          });
        },
        items: [
          bmnav.BottomNavItem(Icons.event, label: "События"),
          bmnav.BottomNavItem(Icons.account_circle, label: "Вакансии"),
        ],
      ),
    );
  }
}


