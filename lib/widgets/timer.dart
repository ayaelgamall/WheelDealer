import 'dart:async';

import 'package:flutter/material.dart';

class CardTimer extends StatefulWidget {
  DateTime deadline;
  CardTimer({super.key, required this.deadline});

  @override
  State<CardTimer> createState() => _CardTimerState();
}

class _CardTimerState extends State<CardTimer> {
  Timer? countdownTimer;
  var dateDiff;
  bool bidEnded = false;

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final seconds = dateDiff.inSeconds - 1;
    if (seconds <= 0) {
      setState(() {
        bidEnded = true;
      });
    } else {
      setState(() {
        dateDiff = Duration(seconds: seconds);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    dateDiff = widget.deadline.difference(DateTime.now());
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    var remDays = dateDiff.inDays;
    var remHours = strDigits(dateDiff.inHours);
    var remMin = strDigits(dateDiff.inMinutes.remainder(60));
    var remSec = strDigits(dateDiff.inSeconds.remainder(60));

    return Text(bidEnded ? "Bid ended" : "${remDays}D:${remHours}H:${remMin}M:${remSec}S",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ));
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }
}