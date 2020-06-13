import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<Data> fetchData(
    {String url = 'http://www.boredapi.com/api/activity'}) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Data.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class Data {
  final String activity;
  final String accessibility;
  final String type;
  final String participants;
  final String price;
  final String link;
  final String key;

  Data(
      {this.activity,
      this.accessibility,
      this.type,
      this.participants,
      this.price,
      this.link,
      this.key});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        activity: json['activity'].toString(),
        accessibility: json['accessibility'].toString(),
        type: json['type'].toString(),
        participants: json['participants'].toString(),
        price: json['price'].toString(),
        link: json['link'].toString(),
        key: json['key'].toString());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SuggestionPage(),
    );
  }
}

class SuggestionPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void handleTap() {
    setState(() {
      futureData = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
      // Column is also a layout widget. It takes a list of children and
      // arranges them vertically. By default, it sizes itself to fit its
      // children horizontally, and tries to be as tall as its parent.
      //
      // Invoke "debug painting" (press "p" in the console, choose the
      // "Toggle Debug Paint" action from the Flutter Inspector in Android
      // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      // to see the wireframe for each widget.
      //
      // Column has various properties to control how it sizes itself and
      // how it positions its children. Here we use mainAxisAlignment to
      // center the children vertically; the main axis here is the vertical
      // axis because Columns are vertical (the cross axis would be
      // horizontal).
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder<Data>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Column(children: <Widget>[
                      Image.asset('img/logo.png'),
                      Card(
                          color: Colors.teal[300],
                          child: Column(children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 20.0),
                                child: Column(children: <Widget>[
                                  Card(
                                      elevation: 0.0,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 20.0),
                                          child: Center(
                                              child: Text(
                                                  "${snapshot.data.activity}")))),
                                  Row(children: <Widget>[
                                    Row(children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0,
                                              right: 10.0,
                                              top: 10.0,
                                              bottom: 10.0),
                                          child: Icon(Icons.group,
                                              color: Colors.white)),
                                      Text('${snapshot.data.participants}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Text("${snapshot.data.type}")
                                  ])
                                ]))
                          ])),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                RaisedButton(
                                    onPressed: handleTap,
                                    color: Colors.orange[300],
                                    child: Text('More')),
                                FlatButton(
                                    onPressed: () => {print('filters')},
                                    child: Text('Filter'))
                              ]))
                    ]));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }),
      ],
    ))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
