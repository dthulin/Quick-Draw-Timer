// import 'dart:io';
// import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:developer';

class InterfacePage extends StatefulWidget {
  InterfacePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InterfacePageState createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  void _playBackground() async {
    await audioPlayer.stop();
    audioPlayer = await audioCache.loop('audio/Intro.wav');
  }

  @override
  Widget build(BuildContext context) {
    _playBackground();
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
                new Image.asset(
                  'assets/images/Cowboys_Holstered.png',
                  width: screenSize.width,
                  // height: screenSize.height,
                  fit: BoxFit.fitWidth,
                  // fit: BoxFit.fill,
                ),
                InkWell(
                  onTap: () async {
                    // await audioPlayer.stop();
                    // audioPlayer = await audioCache.play('audio/Gunshot.wav');
                    // audioPlayer.play('audio/Intro.wav', isLocal: true);
                    // setState(() {
                    //   this._shot = !_shot;
                    // });
                    // Navigator.pop(context);
                    await audioPlayer.stop();
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
