import 'package:flutter/material.dart';
import 'landing.dart';
import 'player.dart';

AudioController player = new AudioController();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Draw!',
      theme: ThemeData(
        fontFamily: 'Vanilla',
        primarySwatch: Colors.orange,
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 42.0),
          title: TextStyle(fontSize: 18.0),
          body1: TextStyle(fontSize: 24.0),
        ),
      ),
      home: LandingPage(
        title: 'Quick Draw!',
        player: player,
      ),
    );
  }
}
