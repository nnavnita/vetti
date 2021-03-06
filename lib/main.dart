import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<Data> fetchData(String url) async {
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
  String url;
  String participants;
  String genre;

  @override
  void initState() {
    super.initState();
    url = 'http://www.boredapi.com/api/activity';
    futureData = fetchData(url);
    participants = 'any';
    genre = 'any';
  }

  void handleMoreTap() {
    if (participants == 'any') {
      if (genre == 'any') {
        setState(() {
          futureData = fetchData(url);
        });
      } else {
        setState(() {
          futureData = fetchData('${url.toString()}?type=${genre.toString()}');
        });
      }
    } else {
      if (genre == 'any') {
        setState(() {
          futureData = fetchData(
              '${url.toString()}?participants=${participants.toString()}');
        });
      } else {
        setState(() {
          futureData = fetchData(
              '${url.toString()}?participants=${participants.toString()}&type=${genre.toString()}');
        });
      }
    }
  }

  void handleParticipants(String newValue) {
    setState(() {
      participants = newValue;
    });
    Navigator.pop(context);
    handleFilterTap();
  }

  void handleGenres(String newValue) {
    setState(() {
      genre = newValue;
    });
    Navigator.pop(context);
    handleFilterTap();
  }

  void handleFilterSelectionTap() {
    Navigator.pop(context);
    handleMoreTap();
  }

  void handleFilterTap() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: new Wrap(children: <Widget>[
            Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Participants"),
                        DropdownButton<String>(
                          value: participants,
                          items: <String>['any', '1', '2', '3', '4', '5']
                              .map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: handleParticipants,
                        )
                      ])),
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Genre"),
                        DropdownButton<String>(
                          value: genre,
                          items: <String>[
                            'any',
                            'busywork',
                            'charity',
                            'cooking',
                            'diy',
                            'education',
                            'music',
                            'recreational',
                            'relaxation',
                            'social'
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: handleGenres,
                        )
                      ])),
              RaisedButton(
                  onPressed: handleFilterSelectionTap,
                  color: Colors.orange[300],
                  child: Text('Apply filters',
                      style: TextStyle(fontWeight: FontWeight.w300)))
            ])
          ]));
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
                String activity = '';
                String participants = '';
                String genre = '';
                if (snapshot.data.activity == 'null') {
                  activity =
                      "Oops! Looks like we can't find a suitable activity 😔, please check your filters.";
                  participants = '-';
                  genre = '-';
                } else {
                  activity = snapshot.data.activity;
                  participants = snapshot.data.participants;
                  genre = snapshot.data.type;
                }
                return Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Column(children: <Widget>[
                      Image.asset('img/inapp.png'),
                      Card(
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.teal[300],
                          child: Column(children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 20.0),
                                child: Column(children: <Widget>[
                                  Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white70, width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 0.0,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 20.0),
                                          child: Center(
                                              child: Text(
                                                  "${activity.toString()}")))),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 5.0,
                                                  top: 10.0,
                                                  bottom: 10.0),
                                              child: Icon(Icons.group,
                                                  color: Colors.white)),
                                          Text('${participants.toString()}',
                                              style: TextStyle(
                                                  color: Colors.white))
                                        ]),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: 10.0,
                                                top: 10.0,
                                                bottom: 10.0),
                                            child: Row(children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5.0),
                                                  child: Text("for",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .w300))),
                                              Text("${genre.toString()}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ]))
                                      ])
                                ]))
                          ])),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                RaisedButton(
                                    onPressed: handleMoreTap,
                                    color: Colors.orange[300],
                                    child: Text('More',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300))),
                                FlatButton(
                                    // onPressed: handleFilterTap,
                                    onPressed: handleFilterTap,
                                    child: Text('Filter',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300)))
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
