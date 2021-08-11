# Timer Countdown

A simple customizable timer for counting down a given time.


## Preview
![](https://github.com/appinioGmbH/flutter_packages/tree/main/assets/timer_countdown/screenshot_1.png)


## Getting Started

The simplest example to count down a given time is shown below:

```dart
class MyTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
      format: CountDownTimerFormat.daysHoursMinutesSeconds,
      endTime: DateTime.now().add(
        Duration(
          days: 5,
          hours: 14,
          minutes: 27,
          seconds: 34,
        ),
        onEnd: () {
          print("Timer finished");
        },
      ),
    );
  }
}
```

<hr/>
Made with ❤ by Flutter team at [Appinio GmbH](https://appinio.com)




