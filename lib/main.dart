import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TableTennis(),
    );
  }
}

class TableTennis extends StatefulWidget {
  @override
  _TableTennisState createState() => _TableTennisState();
}

enum TtsState { playing, stopped }

List players = [
  "Zihuny",
  "Noori",
  "Imran",
  "Naamy",
  "Majudhu",
];

List _players = [
  "zehunee",
  "nuuree",
  "Imran",
  "Naamee",
  "Muhjoo",
];



class _TableTennisState extends State<TableTennis> {
  String player1 = 'Player 1', player2 = 'Player 2';
  int p1Index = -1, p2Index = -1;

  int p1 = 0, p2 = 0;
  double fontSize = 300;

  bool p1Serving = false;
  bool gameStarted = false;
  bool p1Started = true;

  // TTS
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 1.0;
  double pitch = 1.5;
  double rate = 0.3;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if ((p1 == 0 && p2 == 0) & !gameStarted) {
                      _newVoiceText = "${(p1Index > -1 ? _players[p1Index] : player1)} will serve first";
                      _speak();

                      setState(() {
                        p1Serving = true;
                      });
                      gameStarted = true;
                      return;
                    }

                    setState(() {
                      p1++;

                      _newVoiceText = p1Started ? "$p1 $p2" : "$p2 $p1";

                      if ((p1 + p2) % 2 == 0) {
                        p1Serving = !p1Serving;
                        _newVoiceText +=
                            "..... ${p1Serving ? (p1Index > -1 ? _players[p1Index] : player1) : (p1Index > -1 ? _players[p2Index] : player2)} is serving next";
                      }

                      _speak();
                    });
                  },
                  onLongPress: () {
                    if (p1 == 0) return;

                    setState(() {
                      p1--;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    child: Text(
                      p1.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if ((p1 == 0 && p2 == 0) & !gameStarted) {
                      _newVoiceText = "${(p2Index > -1 ? _players[p2Index] : player2)} will serve first";
                      _speak();

                      setState(() {
                        p1Serving = false;
                      });
                      gameStarted = true;
                      p1Started = false;
                      return;
                    }

                    setState(() {
                      p2++;

                      _newVoiceText = p1Started ? "$p1 $p2" : "$p2 $p1";

                      if ((p1 + p2) % 2 == 0) {
                        p1Serving = !p1Serving;
                        _newVoiceText +=
                        "..... ${p1Serving ? (p1Index > -1 ? _players[p1Index] : player1) : (p1Index > -1 ? _players[p2Index] : player2)} is serving next";
                      }

                      _speak();
                    });
                  },
                  onLongPress: () {
                    if (p2 == 0) return;

                    setState(() {
                      p2--;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    child: Text(
                      p2.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (p1Index == players.length - 1)
                            p1Index = 0;
                          else
                            p1Index++;

                          setState(() {
                            player1 = players[p1Index];
                          });
                        },
                        child: Text(
                          p1Index > -1 ? players[p1Index] : player1,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      )),
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (p2Index == players.length - 1)
                            p2Index = 0;
                          else
                            p2Index++;

                          setState(() {
                            player2 = players[p2Index];
                          });
                        },
                        child: Text(
                          p2Index > -1 ? players[p2Index] : player2,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ((p1 == 0 && p2 == 0) && !gameStarted)
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(
                        left: p1Serving ? 0 : 33, right: p1Serving ? 33 : 0),
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          p1 = p2 = 0;
                          gameStarted = false;
                          p1Started = true;
                          player1 = "Player 1";
                          player2 = "Player 2";
                          p1Index = -1;
                          p2Index = -1;
                        });
                      },
                      child: Icon(
                        p1Serving ? Icons.arrow_left : Icons.arrow_right,
                        size: 200,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
