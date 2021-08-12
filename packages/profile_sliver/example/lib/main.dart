import 'package:flutter/material.dart';
import 'package:profile_sliver/profile_sliver.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile Sliver Example',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [Icon(Icons.notifications)],
          ),
          body: CustomScrollView(
            slivers: [
              ProfileSliver(
                headerHeight: 200,
                header: Container(
                  height: 20,
                  color: Color(0xFF053149),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      SizedBox(height: 20),
                      Icon(
                        Icons.arrow_downward,
                        size: 40,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                body: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  height: 60,
                  child: Center(child: Text("Body")),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                    height: 50, child: Center(child: Text("$index")));
              }, childCount: 50))
            ],
          ),
        ));
  }
}
