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
        dateDiff = Duration(days: 0, minutes: 0, seconds: 0, hours: 0);
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
    dateDiff = widget.deadline.difference(DateTime.now());
    final zeroDuration = Duration(days: 0, seconds: 0, minutes: 0);
    // dateDiff = zeroDuration;
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String strDigits(int n) => n.toString().padLeft(2, '0');
    var remDays = dateDiff.inDays;
    var remHours = strDigits(dateDiff.inHours.remainder(24));
    var remMin = strDigits(dateDiff.inMinutes.remainder(60));
    var remSec = strDigits(dateDiff.inSeconds.remainder(60));

    return Text(
        bidEnded
            ? "Bid ended"
            :remDays!=0? "${remDays}D:${remHours}H:${remMin}M:${remSec}S":
            remHours!='0'? "${remHours}H:${remMin}M:${remSec}S":
            remMin!='0'? "${remMin}M:${remSec}S":'${remSec}S',
        style: const TextStyle(
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
