import 'package:flutter/material.dart';
import 'landing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Draw!',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LandingPage(title: 'Quick Draw!'),
    );
  }
}
