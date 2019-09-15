import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_view/photo_view.dart';


class MapPage extends StatelessWidget {
  // This widget is the root of your application.

  final ref = FirebaseStorage.instance.ref().child('Maps');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
            future: ref.child('mero1.png').getDownloadURL(),
            builder: (BuildContext context, AsyncSnapshot url) {
              switch (url.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Awaiting result...');
                case ConnectionState.done:
                  if (url.hasError)
                    return Text('Error: ${url.error}');
                  print("HELLOOO!!!!!!!!!!!");
                  print('Result: ${url.data}');
                  return Container(
                    child: Column(
                        children: <Widget>[
                          AppBar(
                            elevation: 0.0,
                            title: Text("Карта"),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.exit_to_app),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed('/home');
                                },
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(
                              child: PhotoView(
                                imageProvider: new NetworkImage(url.data),
                                backgroundDecoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                    ),
                  );
              }
              return null;
            },
          );
  }
}
