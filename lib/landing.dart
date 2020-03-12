import 'dart:async';
import 'timer.dart';
import 'player.dart';

import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.title, this.player}) : super(key: key);

  final String title;
  final AudioController player;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  int _shotSpeed = 200;
  int _smokeSpeed = 800;
  int _transitionSpeed = 1000;
  //_transitionSpeed must be higher than _smokeSpeed to ensure _smokeSpeed is finished.
  bool _shot = false;
  bool _hideAimed = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: InkWell(
        onTap: () async {
          widget.player.playFile('Gunshot');
          new Timer(Duration(milliseconds: _shotSpeed), () {
            setState(() {
              _shot = !_shot;
            });
            new Timer(
              Duration(milliseconds: _smokeSpeed),
              () {
                setState(() {
                  _hideAimed = !_hideAimed;
                });
              },
            );
            new Timer(
              Duration(milliseconds: _transitionSpeed),
              () {
                widget.player.playFileLoop('Intro');
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration:
                        Duration(milliseconds: _transitionSpeed),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        TimerPage(player: widget.player),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            );
          });
        },
        enableFeedback: false,
        child: Stack(
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/images/Background.png',
                width: screenSize.width,
                height: screenSize.height,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: new Opacity(
                opacity: _hideAimed ? 0.0 : 1.0,
                child: new Image.asset(
                  'assets/images/Logo_Aimed.png',
                ),
              ),
            ),
            Center(
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: _smokeSpeed),
                curve: Curves.slowMiddle,
                child: Container(
                  height: _shot ? screenSize.width / 2 : 0,
                  width: screenSize.width,
                  child: Hero(
                    tag: 'logo',
                    child: new Image.asset(
                      'assets/images/Logo_Shot.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
