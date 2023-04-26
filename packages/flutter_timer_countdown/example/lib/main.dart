import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:example/timer_basic.dart';
import 'package:example/timer_frame.dart';
import 'package:flutter_timer_countdown/timer_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TimerController? timerController = TimerController();

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
                description: 'without minutes & seconds',
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
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                description: 'Reverse Countdown',
                inverted: true,
                timer: TimerBasic(
                  format: CountDownTimerFormat.secondsOnly,
                  inverted: true,
                  isReverse: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TimerFrame(
                description: 'Reverse Countdown',
                timer: TimerBasic(
                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                  isReverse: true,
                  timerController: timerController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => timerController?.start(),
                    child: Text("START"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (timerController?.state == TimerState.paused)
                        timerController?.resume();
                      else
                        timerController?.pause();
                      setState(() {});
                    },
                    child: Text(timerController?.state == TimerState.paused
                        ? "RESUME"
                        : "PAUSE"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),
                  ElevatedButton(
                    onPressed: () => timerController?.stop(),
                    child: Text("STOP"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
