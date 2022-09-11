import 'package:flutter/cupertino.dart';

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:example/timer_basic.dart';
import 'package:example/timer_frame.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: CupertinoPageScaffold(
        child: SafeArea(
          minimum: EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                description: 'Customized Timer Countdown',
                timer: TimerBasic(
                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                inverted: true,
                description: 'without seconds',
                timer: TimerBasic(
                  format: CountDownTimerFormat.daysHoursMinutes,
                  inverted: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                description: 'whitout minutes & seconds',
                timer: TimerBasic(
                  format: CountDownTimerFormat.daysHours,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                inverted: true,
                description: 'only days',
                timer: TimerBasic(
                  format: CountDownTimerFormat.daysOnly,
                  inverted: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                description: 'only hours',
                timer: TimerBasic(
                  format: CountDownTimerFormat.hoursOnly,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                inverted: true,
                description: 'only minutes',
                timer: TimerBasic(
                  format: CountDownTimerFormat.minutesOnly,
                  inverted: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                description: 'only seconds',
                timer: TimerBasic(
                  format: CountDownTimerFormat.secondsOnly,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
