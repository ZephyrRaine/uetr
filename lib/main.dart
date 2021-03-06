// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormat = new NumberFormat("#,##0.00", "en_US");

void main() => runApp(MyApp());

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) {
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

class Person {
  final String name;
  final num money;
  final String location;
  final num age;

  const Person(this.name, this.money, this.location, this.age);
}

class FoodCard extends StatelessWidget {
  final Person myPerson;
  const FoodCard(this.myPerson, {Key key}) : super(key: key);

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
            SizedBox(
              height: 184.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
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
                        myPerson.name,
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
                        title: Text(myPerson.location,
                            style: descriptionStyle.copyWith(
                                color: Colors.black54)),
                        leading: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    Center(
                        child: Text(
                            "\$${currencyFormat.format(myPerson.money)}",
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
                        builder: (context) => PersonDetail(myPerson)));
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

class MyApp extends StatelessWidget {
  final listOfPerson = <Person>[
    new Person(
        "Jeff Bezos", 177000000000, "Seattle, Washington, United States", 57),
    new Person("Elon Musk", 151000000000, "Austin, Texas, United States", 49),
    new Person("Bernard Arnault & family", 150000000000, "Paris, France", 72),
  ];

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
            children: [for (var person in listOfPerson) FoodCard(person)],
          ),
        ));
  }
}

class PersonDetail extends StatelessWidget {
  final Person person;
  const PersonDetail(this.person, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: Container(
          child: Center(
        child: Column(children: [
          Text(person.name),
          Text(person.location),
          Text(person.age.toString() + " years old"),
          Text(person.money.toString() + " dollars"),
        ]),
      )),
    );
  }
}
