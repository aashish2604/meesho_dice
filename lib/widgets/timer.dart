import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class TimerBox extends StatelessWidget {
  final DateTime endTime;
  const TimerBox({super.key, required this.endTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 10, top: 2, bottom: 2),
      decoration: BoxDecoration(
          color: Colors.deepPurple, borderRadius: BorderRadius.circular(30.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_filled_outlined,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(
            width: 4,
          ),
          TimerCountdown(
            endTime: endTime,
            spacerWidth: 4,
            enableDescriptions: false,
            timeTextStyle: TextStyle(color: Colors.white, fontSize: 12),
            colonsTextStyle: TextStyle(color: Colors.white, fontSize: 12),
            hoursDescription: "",
            minutesDescription: "",
            secondsDescription: "",
            format: CountDownTimerFormat.hoursMinutesSeconds,
          )
        ],
      ),
    );
  }
}
