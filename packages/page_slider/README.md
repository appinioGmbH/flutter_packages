# page_slider

A page slider with parallex design that allows (Text) widgets or body to slide at a different speed with background.

## Features

* Parralex design of the background that allows background to slide at a different speed.
* A bottom controller that indicates the current page.
* A bottom button in the end.
* A skip button on the top right with a final function.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  page_slider:
```

In your library add the following import:

```dart
import 'package:page_slider/page_slider.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Usage

You can place your `PageSlider` inside of a `MaterialApp`, optional parameters can be defined to enable different featiures. See the following example

```dart
return MaterialApp(
      home: PageSlider(
        buttonText: 'New Page',
        onPageFinish: (BuildContext newContext) {
          Navigator.push(
            newContext,
            MaterialPageRoute(builder: (context) => NewPage()),
          );
        },
        skipTextButton: Text('skip'),
        finishButton: Text('new page'),
        onFinish: (BuildContext newContext) {
          Navigator.push(
            newContext,
            MaterialPageRoute(builder: (context) => NewPage()),
          );
        },
        controllerColor: Colors.blue,
        totalPage: 3,
        headerBackgroundColor: Colors.white,
        background: [
          Image.asset('assets/flutter.jpg'),
          Image.asset('assets/flutter.jpg'),
          Image.asset('assets/flutter.jpg'),
        ],
        speed: 1.4,
        bodyHeight: 540,
        bodyWidth: 500,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Text(
                  'Flutter Parallex Design Example',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Text(
                  'Flutter Parallex Design Example',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Text(
                  'Flutter Parallex Design Example',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
```

You can find more details in the `Github` project.
