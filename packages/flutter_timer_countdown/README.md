# Timer Countdown

A simple customizable timer for counting down a given time.


## Preview
<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/timer_countdown/screenshot_1.png?raw=true" height="800">


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
      ),
      onEnd: () {
        print("Timer finished");
      },
    );
  }
}
```

<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>




