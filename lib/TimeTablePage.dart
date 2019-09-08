import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class TimeTablePage extends StatelessWidget {
  // This widget is the root of your application.

  final ref = FirebaseDatabase.instance.reference().child('time_tables');

  List<Widget> _buildSlivers(BuildContext context, snapVal) {
    List<Widget> slivers = new List<Widget>();

    slivers.add(SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text('Расписание'),
      pinned: true,
    ));

    slivers.addAll(_buildHeaderBuilderLists(context, snapVal));


    return slivers;
  }

  List<Widget> _buildHeaderBuilderLists(BuildContext context, snapVal){

    List _list=snapVal.keys.toList();

  return List.generate(_list.length, (sliverIndex) {
    print(sliverIndex);
    print(_list[sliverIndex]);
    return new SliverStickyHeaderBuilder(
      builder: (context, state) =>
        _buildAnimatedHeader(context, _list[sliverIndex].toString(), state),
      sliver: new SliverList(
        delegate: new SliverChildBuilderDelegate(
          (context, i) => new ListTile(
            leading: new CircleAvatar(
              child: new Text('$sliverIndex'),
            ),
            title: new Text('List tile #$i'),
          ),
          //childCount: snapVal[_list[sliverIndex]].length,
          childCount: 20
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
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
  String key;
  String title;
  String startTime;
  String endTime;
  String description;

  TimeTableEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"],
        startTime = snapshot.value["start_time"],
        endTime = snapshot.value["end_time"],
        description = snapshot.value["description"];
}
