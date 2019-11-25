import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

typedef TimeProducer = DateTime Function();

class Clock extends StatefulWidget {
  final TimeProducer getCurrentTime;
  final Duration updateDuration;

  Clock(
      {this.getCurrentTime = getSystemTime,
      this.updateDuration = const Duration(seconds: 1)});

  static DateTime getSystemTime() {
    return new DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    return _Clock();
  }
}

class _Clock extends State<Clock> {
  Timer _timer;
  DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();
    this._timer = new Timer.periodic(widget.updateDuration, setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(50.0),
      child: AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: <Widget>[
              buildClockCircle(context),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: buildClockCircleSmall(context),
              ),
            ],
          )),
    );
  }

  Container buildClockCircleSmall(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xffF3F4F6),
                Color(0xffC4CFF0),
                Color(0xffB1C1ED)
              ])),
      child: Stack(
        children: <Widget>[
          new ClockHands(dateTime: dateTime),
        ],
      ),
    );
  }

  Container buildClockCircle(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 40,
              offset: Offset(50, 0), // changes position of shadow
            ),
          ],
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffF4F5F7),
                Color(0xffBFCCEF),
                Color(0xffBBC9EF),
              ])),
      child: null,
    );
  }
}

class ClockHands extends StatelessWidget {
  final DateTime dateTime;
  final bool showHourHandleHeartShape;

  ClockHands({this.dateTime, this.showHourHandleHeartShape = false});

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: new Stack(fit: StackFit.expand, children: <Widget>[
              new CustomPaint(
                painter: new HourHandPainter(
                    hours: dateTime.hour, minutes: dateTime.minute),
              ),
              new CustomPaint(
                painter: new MinuteHandPainter(
                    minutes: dateTime.minute, seconds: dateTime.second),
              ),
            ])));
  }
}

class HourHandPainter extends CustomPainter {
  final Paint hourHandPaint;
  int hours;
  int minutes;

  HourHandPainter({this.hours, this.minutes}) : hourHandPaint = new Paint() {
    hourHandPaint.color = Color(0xff1348DB);
    hourHandPaint.style = PaintingStyle.stroke;
    hourHandPaint.strokeWidth = 10.0;
    hourHandPaint.strokeCap = StrokeCap.round;
    hourHandPaint.strokeJoin = StrokeJoin.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    // To draw hour hand
    canvas.save();

    canvas.translate(radius, radius);

    //checks if hour is greater than 12 before calculating rotation
    canvas.rotate(this.hours >= 12
        ? 2 * pi * ((this.hours - 12) / 12 + (this.minutes / 720))
        : 2 * pi * ((this.hours / 12) + (this.minutes / 720)));

    Path path = new Path();
    //hour hand stem
    path.moveTo(0.0, -radius * 0.5);
    path.lineTo(0.0, radius * 0.0);

    canvas.drawPath(path, hourHandPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourHandPainter oldDelegate) {
    return true;
  }
}

class MinuteHandPainter extends CustomPainter {
  final Paint minuteHandPaint;
  int minutes;
  int seconds;

  MinuteHandPainter({this.minutes, this.seconds})
      : minuteHandPaint = new Paint() {
    minuteHandPaint.color = const Color(0xff1348DB);
    minuteHandPaint.style = PaintingStyle.stroke;
    minuteHandPaint.strokeCap = StrokeCap.round;
    minuteHandPaint.strokeWidth = 10.0;
    minuteHandPaint.strokeJoin = StrokeJoin.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * ((this.minutes + (this.seconds / 60)) / 60));

    Path path = new Path();
    path.moveTo(0.0, -radius * 0.9);
    path.lineTo(0.0, radius * 0.0);

    path.close();

    canvas.drawPath(path, minuteHandPaint);
    canvas.drawShadow(path, Colors.black, 4.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(MinuteHandPainter oldDelegate) {
    return true;
  }
}
