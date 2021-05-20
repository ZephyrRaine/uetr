// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:untitled1/people.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormat = new NumberFormat("#,##0.00", "en_US");

final people = <Person>[
  new Person("Jeff Bezos", 177000000000, "Seattle, Washington, United States", 57),
  new Person("Elon Musk", 151000000000, "Austin, Texas, United States", 49),
  new Person("Bernard Arnault & family", 150000000000, "Paris, France", 72),
];

void main() => runApp(MyApp());

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) {
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Eat the rich"),
            leading: Icon(Icons.restaurant),
          ),
          body: ListView(
            children: [for (var person in people) FoodCard(person)],
          ),
        ));
  }
}

class FoodCard extends StatelessWidget {
  final Person person;
  const FoodCard(this.person, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline5.copyWith(
        color: Colors.white,
        shadows: <Shadow>[
          Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 0.5)
        ]);
    final TextStyle descriptionStyle = theme.textTheme.subtitle1;
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
        primary: Colors.amber.shade500,
        textStyle: descriptionStyle.copyWith(fontSize: 25));

    return Container(
        height: 400,
        padding: EdgeInsets.all(10.0),
        child: Card(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
// Photo and title.
            SizedBox(
              height: 184.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
// In order to have the ink splash appear above the image, you
// must use Ink.image. This allows the image to be painted as part
// of the Material and display ink effects above it. Using a
// standard Image will obscure the ink splash.
                    child: Image.network(
                      'https://picsum.photos/200/300?${getRandomString(10)}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        person.name,
                        style: titleStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
// Description and share/explore buttons.
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: DefaultTextStyle(
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: descriptionStyle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// three line description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(person.location,
                            style: descriptionStyle.copyWith(
                                color: Colors.black54)),
                        leading: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    Center(
                        child: Text("\$${currencyFormat.format(person.money)}",
                            style: theme.textTheme.headline4
                                .copyWith(color: Colors.black))),
                  ],
                ),
              ),
            ),

// share, explore buttons
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: textButtonStyle.copyWith(),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PersonDetail(person)));
                  },
                  child: Text('DETAILS', semanticsLabel: 'Eat '),
                ),
                TextButton(
                  style: textButtonStyle,
                  onPressed: () {
                    print('pressed');
                  },
                  child: Text('EAT', semanticsLabel: 'Explore  '),
                ),
              ],
            ),
          ],
        )));
  }
}

class PersonDetail extends StatelessWidget {
  final Person person;
  const PersonDetail(this.person, {Key key}) : super(key: key);

  Widget buildRow(String key, String data) {
    return Row(children: [
      SizedBox(width: 60, child: Text("$key")),
      SizedBox(width: 54),
      Text(
        "$data",
        textAlign: TextAlign.left,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${person.name}"),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text("Location"),
              ),
              SizedBox(
                  height: 200,
                  child: Image.network(
                    'https://leafletjs.com/examples/quick-start/thumbnail.png',
                    fit: BoxFit.cover,
                  )),
              Container(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    ListTile(
                      title: Text("Infos"),
                    ),
                    buildRow("Nom", person.name),
                    buildRow("Age", "${person.age} years old"),
                    buildRow("Location", person.location),
                    buildRow("Fortune", "${person.money} dollars"),
                  ]))
            ],
          )),
    );
  }
}
