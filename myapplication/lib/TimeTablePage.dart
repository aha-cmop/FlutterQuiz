import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TimeTablePage extends StatelessWidget {
  // This widget is the root of your application.

  final ref = FirebaseDatabase.instance.reference().child('time_tables');
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  List<Widget> _buildSlivers(BuildContext context, snapVal) {

    unpickEvent()  async  {
      final SharedPreferences prefs = await _sprefs;
      prefs.setBool('picked', false);
      Navigator.of(context).pushReplacementNamed('/home');
    }

    List<Widget> slivers = new List<Widget>();

    slivers.add(SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text('Расписание'),
      pinned: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: unpickEvent,
        )
      ],
    ));

    slivers.addAll(_buildHeaderBuilderLists(context, snapVal));


    return slivers;
  }

  List<Widget> _buildHeaderBuilderLists(BuildContext context, snapVal){

    List _list=snapVal.keys.toList();

  return List.generate(_list.length, (sliverIndex) {
    print(sliverIndex);
    print(_list[sliverIndex]);

    var events = snapVal[_list[sliverIndex]];
    var eventsList = snapVal[_list[sliverIndex]].keys.toList();
    return new SliverStickyHeaderBuilder(
      builder: (context, state) =>
        _buildAnimatedHeader(context, _list[sliverIndex].toString(), state),
      sliver: new SliverList(
        delegate: new SliverChildBuilderDelegate(
          (context, i) {
            var event = TimeTableEntry.fromSnapshot(events[eventsList[i]]);
            return new ExpansionTile(
                leading: new Column(
                  children: <Widget>[
                    new Text(
                      event.startTime,),
                    new Text(
                      event.endTime,
                      style: const TextStyle(color: Colors.grey)),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                title: new Text(event.title),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: Text(event.description),
                  ),

                ],
            );
          },
          childCount: eventsList.length,
          ),
        ),
      );

  });

  }

  Widget _buildAnimatedHeader(
      BuildContext context, String index, SliverStickyHeaderState state) {
    return GestureDetector(
      onTap: () => Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: Text(index))),
      child: new Container(
        height: 60.0,
        color: (state.isPinned ? Colors.pink : Colors.lightBlue)
            .withOpacity(1.0 - state.scrollPercentage),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: new Text(
          index,
          style: const TextStyle(color: Colors.white, fontSize: 17.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.child('mero1').onValue,
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {
          DataSnapshot snapshot = snap.data.snapshot;

          return snap.data.snapshot.value == null
          ? SizedBox()
          : Builder(builder: (BuildContext context) {
              return new CustomScrollView(
              slivers: _buildSlivers(context, snapshot.value),
            );
          });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _containerForCat extends StatelessWidget {
  const _containerForCat({
    Key key,
    this.catName,
    this.events,
  }) : super(key: key);

  final catName;
  final events;

  @override
  Widget build (BuildContext ctxt) {
    List _keys=events.keys.toList();

    return new Text(events);
  }
}

class TimeTableEntry {
  String title;
  String startTime;
  String endTime;
  String description;

  TimeTableEntry.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : title = snapshot["title"],
        startTime = snapshot["start_time"],
        endTime = snapshot["end_time"],
        description = snapshot["description"];
}
