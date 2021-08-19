import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Timer Countdown"),
        ),
        child: SafeArea(
          minimum: EdgeInsets.all(20),
          child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Customized Timer Countdown",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TimerCountdown(
                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                  endTime: DateTime.now().add(
                    Duration(
                      days: 5,
                      hours: 14,
                      minutes: 27,
                      seconds: 34,
                    ),
                  ),
                  onEnd: () {
                    print("Timer finished");
                  },
                  timeTextStyle: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  colonsTextStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  descriptionTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                  spacerWidth: 20,
                  daysDescription: "d",
                  hoursDescription: "h",
                  minutesDescription: "m",
                  secondsDescription: "s",
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Without Seconds",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TimerCountdown(
                  format: CountDownTimerFormat.daysHoursMinutes,
                  endTime: DateTime.now().add(
                    Duration(
                      days: 5,
                      hours: 14,
                      minutes: 27,
                      seconds: 34,
                    ),
                  ),
                  onEnd: () {
                    print("Timer finished");
                  },
                  timeTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  colonsTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  descriptionTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Without Minutes",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TimerCountdown(
                  format: CountDownTimerFormat.daysHours,
                  endTime: DateTime.now().add(
                    Duration(
                      days: 5,
                      hours: 14,
                      minutes: 27,
                      seconds: 34,
                    ),
                  ),
                  onEnd: () {
                    print("Timer finished");
                  },
                  timeTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  colonsTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  descriptionTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Without Hours",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TimerCountdown(
                  format: CountDownTimerFormat.daysOnly,
                  endTime: DateTime.now().add(
                    Duration(
                      days: 5,
                      hours: 14,
                      minutes: 27,
                      seconds: 34,
                    ),
                  ),
                  onEnd: () {
                    print("Timer finished");
                  },
                  timeTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  descriptionTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Only Minutes",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TimerCountdown(
                  format: CountDownTimerFormat.minutesOnly,
                  endTime: DateTime.now().add(
                    Duration(
                      days: 5,
                      hours: 14,
                      minutes: 27,
                      seconds: 34,
                    ),
                  ),
                  onEnd: () {
                    print("Timer finished");
                  },
                  timeTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  descriptionTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
