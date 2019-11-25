import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

// Light theme constant
const Color mainBackground = Color(0xFFE5E9F4);
const Color textBold = Color(0xFF1348DB);
const Color textThin = Color(0xFFACBDEC);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> isSelected;
  DateTime dateTime;
  String formattedTime;
  String formattedDate;
  Timer _timer;

  List<String> litems = ["Paris", "London", "Iran", "New York", "Tokyo"];

  @override
  void initState() {
    isSelected = [false, true, false];
    dateTime = new DateTime.now();
    formattedTime = DateFormat('jm').format(dateTime);
    print(formattedTime);
    formattedDate = DateFormat('EEEE, MMMM d').format(dateTime);
    print(formattedDate);
    this._timer = new Timer.periodic(const Duration(seconds: 1), setTime);
    super.initState();
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
      setState(() {
        formattedTime = DateFormat('jm').format(dateTime);
        print(formattedTime);
        formattedDate = DateFormat('EEEE, MMMM d').format(dateTime);
        print(formattedDate);
        print(dateTime.timeZoneName);
        print(dateTime.timeZoneOffset);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ClockView(
                formattedTime: formattedTime, formattedDate: formattedDate),
            Align(
              alignment: Alignment.bottomCenter,
              child: ToggleButtons(
                borderColor: Colors.transparent,
                fillColor: Colors.transparent,
                borderWidth: 1,
                selectedBorderColor: Colors.transparent,
                selectedColor: textBold,
                color: textThin,
                children: <Widget>[
                  isSelected[0]
                      ? Padding(
                          padding: const EdgeInsets.only(right: 90.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.notifications,
                                size: 32.0,
                              ),
                              Text(
                                'Alarm',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 90.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.notifications,
                                size: 32.0,
                              ),
                            ],
                          ),
                        ),
                  isSelected[1]
                      ? Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.timer,
                                size: 32.0,
                              ),
                              Text(
                                'Clock',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.timer,
                                size: 32.0,
                              ),
                            ],
                          ),
                        ),
                  isSelected[2]
                      ? Padding(
                          padding: const EdgeInsets.only(left: 90.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.settings,
                                size: 32.0,
                              ),
                              Text(
                                'Settings',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 90.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.settings,
                                size: 32.0,
                              ),
                            ],
                          ),
                        ),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      if (i == index) {
                        isSelected[i] = true;
                      } else {
                        isSelected[i] = false;
                      }
                    }
                    if (index == 0) {
                      // Alarm
                      print("Alarm");
                    } else if (index == 1) {
                      // Clock
                      print("Clock");
                    } else {
                      // Setting
                      print("Setting");
                    }
                  });
                },
                isSelected: isSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockView extends StatefulWidget {
  final String formattedTime;
  final String formattedDate;

  ClockView({this.formattedTime, this.formattedDate});
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  final List<String> litems = ["Paris", "London", "Iran", "New York", "Tokyo"];

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 24,
          left: 16,
          child: Icon(
            Icons.location_on,
            color: textBold,
            size: 32.0,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              margin: EdgeInsets.only(top: 80),
              height: 60.0,
              child: new ListView.builder(
                  itemCount: litems.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 30, left: 30),
                      child: new GestureDetector(
                        onTap: () {
                          _onSelected(index);
                        },
                        child: new Text(
                          litems[index],
                          style: TextStyle(
                            fontSize: 20.0,
                            color: _selectedIndex != null &&
                                    _selectedIndex == index
                                ? textBold
                                : textThin,
                          ),
                        ),
                      ),
                    );
                  })),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Clock(),
              Text(widget.formattedTime,
                  style: TextStyle(
                    fontSize: 40.0,
                    color: textBold,
                  )),
              SizedBox(
                height: 24.0,
              ),
              Text(widget.formattedDate,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: textBold,
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
