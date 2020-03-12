import 'dart:async';
import 'player.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key key, this.player}) : super(key: key);

  final AudioController player;

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  var _timerAudioFiles = [
    'Timer1',
    'Timer2',
    'Timer3',
    'Timer4',
    'Timer5',
  ];
  bool _drawn = false;
  bool _showReady = false;
  bool _showSpeech = true;
  bool _showTumbleweed = false;
  int _timerCurrentTime = 10;
  int _timerMaxTime = 10;
  bool _timerRunning = false;
  AnimationController _tumbleweedController;
  int _tumbleweedDuration = 5;
  int _tumbleweedSpinSpeed = 500;

  Stream<int> _counterStream;
  StreamSubscription<int> _subscription;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'ARE YA SURE YA GONNA GIT?',
              style: Theme.of(context).textTheme.headline,
            ),
            content: new Text(
              'YA LILY-LIVERED VARMINT...',
              style: Theme.of(context).textTheme.title,
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'NOPE',
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              new FlatButton(
                onPressed: () {
                  widget.player.stop();
                  Navigator.of(context).pop(true);
                },
                child: new Text(
                  'YUP',
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    _tumbleweedController = AnimationController(
      duration: Duration(milliseconds: _tumbleweedSpinSpeed),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tumbleweedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
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
                      ),
                    ),
                  ),
                  Stack(children: <Widget>[
                    Stack(children: <Widget>[
                      new Opacity(
                        opacity: _drawn ? 1.0 : 0.0,
                        child: new Image.asset(
                          'assets/images/Cowboys_Drawn.png',
                          width: screenSize.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      new Opacity(
                        opacity: _drawn ? 0.0 : 1.0,
                        child: new Image.asset(
                          'assets/images/Cowboys_Holstered.png',
                          width: screenSize.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ]),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: new Opacity(
                          opacity: _timerRunning ? 1.0 : 0.0,
                          child: Text(
                            _timerCurrentTime.toString().padLeft(2, '0') + ' ',
                            style: TextStyle(
                              fontFamily: 'Vanilla',
                              fontSize: 42,
                              color: Color(0xFFE89D23),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  InkWell(
                    onTap: () async {
                      if (_showSpeech && !_timerRunning && !_showReady) {
                        widget.player.playFile('Draw');
                        _counterStream = Stream<int>.periodic(
                                Duration(seconds: 1),
                                (elapsed) => _timerMaxTime + 1 - elapsed)
                            .take(_timerMaxTime + 1);
                        _subscription = _counterStream.listen((int counter) {
                          if (!_timerRunning) {
                            widget.player.playFile(
                                (_timerAudioFiles.toList()..shuffle()).first);
                          }
                          setState(() {
                            _showSpeech = false;
                            _showReady = true;
                            _timerRunning = true;
                            _drawn = true;
                            _timerCurrentTime = counter - 1;
                          });
                          print(_timerCurrentTime > 0
                              ? _timerCurrentTime
                              : (_timerCurrentTime).toString() +
                                  "... Time's up!");
                          if (_timerCurrentTime < 1) {
                            _subscription.cancel();
                            widget.player.playFile('Gunfight');
                            new Timer(
                              Duration(seconds: 3),
                              () {
                                setState(() {
                                  _showSpeech = true;
                                  _timerRunning = false;
                                  _drawn = false;
                                });
                              },
                            );
                          }
                        });
                        widget.player.stop();
                      } else if (_showSpeech && !_timerRunning && _showReady) {
                        widget.player.playFile('Tumbleweed');
                        _tumbleweedController.repeat();
                        setState(() {
                          _showSpeech = false;
                          _showTumbleweed = true;
                          _showReady = false;
                        });
                        new Timer(Duration(seconds: _tumbleweedDuration), () {
                          widget.player.playFileLoop('Intro');
                          setState(() {
                            _showSpeech = true;
                            _showTumbleweed = false;
                          });
                        });
                      }
                    },
                    enableFeedback: false,
                    child: Container(
                      width: screenSize.width,
                      child: Stack(children: <Widget>[
                        Center(
                          child: new Opacity(
                            opacity: (_showSpeech && !_showReady) ? 1.0 : 0.0,
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: new Image.asset(
                                'assets/images/Speech_Draw.png',
                                width: screenSize.width * .70,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: new Opacity(
                            opacity: (_showSpeech && _showReady) ? 1.0 : 0.0,
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: new Image.asset(
                                'assets/images/Speech_Ready.png',
                                width: screenSize.width * .70,
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(seconds: _tumbleweedDuration),
                          curve: Curves.easeInOut,
                          child: Center(
                            child: new Opacity(
                              opacity: (_showTumbleweed) ? 1.0 : 0.0,
                              child: RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0)
                                    .animate(_tumbleweedController),
                                child: new Image.asset(
                                  'assets/images/Tumbleweed.png',
                                  width: 150,
                                ),
                              ),
                            ),
                          ),
                          left: _showTumbleweed
                              ? screenSize.width
                              : -screenSize.width / 2,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
