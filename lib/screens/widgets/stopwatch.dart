import 'package:flutter/material.dart';
import 'dart:async';

class StopWatchPlugin extends StatefulWidget {
  @override
  _StopWatchPluginState createState() => _StopWatchPluginState();
}

class _StopWatchPluginState extends State<StopWatchPlugin> {
  bool isStartPressed = false;
  bool isStopPressed = false;
  bool isResetPressed = false;
  String timeValue = "00:00:00";
  Stopwatch stopwatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void callTimer() {
    Timer(duration, keepRunningStopWatch);
  }

  void keepRunningStopWatch() {
    setState(() {
      timeValue = getStopwatchValue();
    });
    callTimer();
  }

  String getStopwatchValue() {
    return ("${stopwatch.elapsed.inHours.toString().padLeft(2, "0")}:${(stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0")}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0")}");
  }

  void startStopWatch() {
    setState(() {
      isStartPressed = true;
    });
    stopwatch.start();
    callTimer();
    // window.console.debug('startStopwatch called');
  }

  @override
  void initState() {
    super.initState();
    startStopWatch();
  }

  @override
  Widget build(BuildContext context) {
    return Text(timeValue, style: const TextStyle(fontSize: 50.0));
  }
}
