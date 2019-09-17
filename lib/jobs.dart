import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => new _JobsState();
}


class _JobsState extends State<Jobs> {

  final url="http://opendata.trudvsem.ru/api/v1/vacancies?offset=1&limit=100";
  TextEditingController editingController = TextEditingController();

  var _filter = "";

  @override
  initState() {
    editingController.addListener(() {
      setState(() {
        _filter = editingController.text;
      });
    });
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  getJobs() async {
    final response = await http.get(url);
    return json.decode(response.body);
  }

  Widget _buildJobCard(jsonValue) {
    final vac = jsonValue["vacancy"];
    print("VALUE");
    print(jsonValue.toString());
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
          child: ListTile(
            title: Text(vac["job-name"]),
            subtitle: Text(vac["salary"]),
            trailing: Icon(Icons.info_outline),
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
        elevation: 0.0,
        title: Text("Вакансии"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: TextField(
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Поиск",
                    hintText: "Поиск",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            FutureBuilder(
              future: getJobs(),
              builder: (BuildContext context, AsyncSnapshot jobsSnap) {
                switch (jobsSnap.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start.');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (jobsSnap.hasError)
                      return Text('Error: ${jobsSnap.error}');
                    print('Result: ${jobsSnap.data}');

                    var asList = jobsSnap.data["results"]["vacancies"];
                    return Expanded(
                      child: ListView.builder(
                        itemCount: asList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          if (_filter != null && _filter != "") {
                            final vac = asList[index]["vacancy"];
                            if (!vac["job-name"].toString().toLowerCase().contains(_filter.toString().toLowerCase()))
                              return Container();
                          }
                          return _buildJobCard(asList[index]);
                        }),
                    );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],

        ),
      ),
    );
  }
}
