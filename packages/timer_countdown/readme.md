# timer_countdown

A simple customizable timer for counting down a given time.




## Getting Started

The simplest example to count down a given time is shown below:

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Timer Countdown"),
        ),
        child: SafeArea(
          child: Center(
            child: TimerCountdown(
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
            ),
          ),
        ),
      ),
  }
}
```




