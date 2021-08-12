import 'package:example/new_page.dart';
import 'package:flutter/material.dart';
import 'package:page_slider/page_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  }
}
