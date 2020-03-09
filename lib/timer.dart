// import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'player.dart';

// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:developer';

class TimerPage extends StatefulWidget {
  TimerPage({Key key, this.player}) : super(key: key);

  final AudioController player;

  @override
  _TimerPageState createState() => _TimerPageState(player: player);
}

class _TimerPageState extends State<TimerPage> {
  AudioController player;
  _TimerPageState({this.player});
  // AudioCache audioCache = AudioCache();
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  // void _playBackground() async {
  //   await audioPlayer.stop();
  //   audioPlayer = await audioCache.loop('audio/Intro.wav');
  // }

  final _random = new Random();
  var _timerAudioFiles = [
    'Timer1',
    'Timer2',
    'Timer3',
    'Timer4',
    'Timer5',
  ];
  bool _timerRunning = false;
  bool _showSpeech = true;
  bool _drawn = false;
  bool _showTumbleweed = false;
  int _timerMaxTime = 10;
  int _timerCurrentTime = 10;

  Stream<int> _counterStream;
  StreamSubscription<int> _subscription;

  @override
  Widget build(BuildContext context) {
    // _playBackground();
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Stack(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Hero(
                    tag: 'logo',
                    child: new Image.asset(
                      'assets/images/Logo_Shot.png',
                      width: screenSize.width * .75,
                      // scale: .25,
                      // width: screenSize.width,
                      // height: screenSize.height * .2,
                      // fit: BoxFit.fitWidth,
                      // fit: BoxFit.fill,
                    ),
                  ),
                ),
                Stack(children: <Widget>[
                  new Image.asset(
                    _drawn
                        ? 'assets/images/Cowboys_Drawn.png'
                        : 'assets/images/Cowboys_Holstered.png',
                    width: screenSize.width,
                    // height: screenSize.height,
                    fit: BoxFit.fitWidth,
                    // fit: BoxFit.fill,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        _timerCurrentTime.toString().padLeft(2, '0'),
                        // '$_timerCurrentTime',
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ),
                ]),
                InkWell(
                  onTap: () async {
                    player.playFile('Draw');
                    // setState(() {
                    //   player.playFile('Draw');
                    //   _drawn = true;
                    //   // _timerCurrentTime = _timerMaxTime;
                    // });
                    _counterStream = Stream<int>.periodic(Duration(seconds: 1),
                            (elapsed) => _timerMaxTime + 1 - elapsed)
                        .take(_timerMaxTime + 1);
                    _subscription = _counterStream.listen((int counter) {
                      // Print an integer every second.
                      if (!_timerRunning) {
                        player.playFile(_timerAudioFiles[
                            _random.nextInt(_timerAudioFiles.length)]);
                      }
                      setState(() {
                        _timerRunning = true;
                        _drawn = true;
                        _timerCurrentTime = counter - 1;
                      });
                      print(_timerCurrentTime > 0
                          ? _timerCurrentTime
                          : (_timerCurrentTime).toString() + "... Time's up!");
                      if (_timerCurrentTime < 1) {
                        _subscription.cancel();
                        player.playFile('Gunfight');
                        setState(() {
                          _timerRunning = false;
                          _drawn = false;
                        });
                      }
                    });
                    // Navigator.pop(context);
                    // await audioPlayer.stop();
                    player.stop();
                  },
                  enableFeedback: false,
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: new Image.asset(
                      'assets/images/Speech_Draw.png',
                      width: screenSize.width * .75,
                      // width: screenSize.width,
                      // height: screenSize.height,
                      // fit: BoxFit.fitWidth,
                      // fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Padding(
          //     padding: EdgeInsets.all(15.0),
          //     child: new Image.asset(
          //       'assets/images/Logo.png',
          //       // scale: .25,
          //       // width: screenSize.width,
          //       height: screenSize.height * .2,
          //       // fit: BoxFit.fitWidth,
          //       // fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Text(
          //         'You have pushed the button this many times:',
          //         // style: Theme.of(context).textTheme.display1,
          //         style: TextStyle(fontSize: 18, color: Colors.red),
          //       ),
          //       Text(
          //         '$_timer',
          //         style: Theme.of(context).textTheme.display1,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
