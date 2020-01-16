import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _TableTennisState extends State<TableTennis> {
  int p1 = 0, p2 = 0;
  double fontSize = 300;

  bool p1Serving = false;

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
                    HapticFeedback.vibrate();

                    if (p1 == 0 && p2 == 0) p1Serving = true;

                    setState(() {
                      p1++;

                      if ((p1 + p2) % 2 == 0)
                        p1Serving = !p1Serving;
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
                    if (p1 == 0 && p2 == 0) p1Serving = false;

                    setState(() {
                      p2++;

                      if ((p1 + p2) % 2 == 0)
                        p1Serving = !p1Serving;
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
          Align(
            alignment: Alignment.center,
            child: (p1 == 0 && p2 == 0)
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(
                        left: p1Serving ? 0 : 33, right: p1Serving ? 33 : 0),
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          p1 = p2 = 0;
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
