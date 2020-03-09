import 'dart:async';
import 'interface.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// playGunshot() async {
//   int result = await audioPlayer.play('assets/audio/Intro.wav', isLocal: true);
//       // await audioPlayer.play('assets/audio/Gunshot.wav', isLocal: true);
//   if (result == 1) {
//     // success
//     print('success?');
//   }
// }

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
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
          await audioPlayer.stop();
          audioPlayer = await audioCache.play('audio/Gunshot.wav');
          // audioPlayer.play('audio/Intro.wav', isLocal: true);
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
                Navigator.push(
                  context,
                  // MaterialPageRoute(
                  //     builder: (BuildContext context) => InterfacePage())
                  PageRouteBuilder(
                    transitionDuration:
                        Duration(milliseconds: _transitionSpeed),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        InterfacePage(),
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
                    // transitionsBuilder: (BuildContext context,
                    //     Animation<double> animation,
                    //     Animation<double> secondaryAnimation,
                    //     Widget child) {
                    //   return SlideTransition(
                    //     position: new Tween<Offset>(
                    //       begin: const Offset(-1.0, 0.0),
                    //       end: Offset.zero,
                    //     ).animate(animation),
                    //     child: new SlideTransition(
                    //       position: new Tween<Offset>(
                    //         begin: Offset.zero,
                    //         end: const Offset(-1.0, 0.0),
                    //       ).animate(secondaryAnimation),
                    //       child: child,
                    //     ),
                    //   );
                    // },
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
                // fit: BoxFit.fitWidth,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: new Opacity(
                opacity: _hideAimed ? 0.0 : 1.0,
                child: new Image.asset(
                  'assets/images/Logo_Aimed.png',
                  // fit: BoxFit.fitWidth,
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
            // InkWell(
            //   onTap: () async {
            //     await audioPlayer.stop();
            //     audioPlayer = await audioCache.play('audio/Gunshot.wav');
            //     // audioPlayer.play('audio/Intro.wav', isLocal: true);
            //     setState(() {
            //       this._shot = !_shot;
            //     });
            //   },
            //   enableFeedback: false,
            //   child: Center(
            //     child: AnimatedCrossFade(
            //       crossFadeState: this._shot
            //           ? CrossFadeState.showSecond
            //           : CrossFadeState.showFirst,
            //       duration: const Duration(seconds: 1),
            //       // firstCurve: Curves.easeOut,
            //       // secondCurve: Curves.easeIn,
            //       // sizeCurve: Curves.bounceOut,
            //       firstChild: new Image.asset(
            //         'assets/images/Logo_Aimed.png',
            //         // fit: BoxFit.fitWidth,
            //       ),
            //       secondChild: new Image.asset(
            //         'assets/images/Logo_Shot.png',
            //         // fit: BoxFit.fitWidth,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
