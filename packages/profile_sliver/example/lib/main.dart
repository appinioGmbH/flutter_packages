import 'package:flutter/material.dart';
import 'package:profile_sliver/profile_sliver.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("ProfileSliver Example"),
      ),
      body: CustomScrollView(
        slivers: [
          ProfileSliver(
            headerHeight: 200,
            header: Container(
              height: 20,
              color: Colors.white,
              child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus maximus fringilla massa et eleifend. Duis pharetra tellus ante, in lacinia ligula egestas eu. Donec ut efficitur augue, sed laoreet massa. Pellentesque risus felis, volutpat a elementum at, semper mattis velit. Fusce a sapien est. Integer maximus odio eu est aliquam imperdiet. In egestas venenatis dolor, id posuere velit ornare consequat. Donec eu suscipit orci, eget egestas justo. Proin suscipit blandit est, eget consectetur nisi pretium a. Aenean lobortis vehicula arcu, sit amet scelerisque metus elementum quis. Aenean maximus, nisl nec iaculis pulvinar, lorem neque feugiat dui, vel viverra velit quam sit amet nulla. Nullam semper suscipit enim ut tincidunt. Quisque vitae enim vel diam volutpat sollicitudin. Suspendisse eros urna, hendrerit eu ipsum ac, tristique mattis ante. Phasellus suscipit dui eu diam vehicula gravida. Duis ultrices faucibus nunc vitae aliquam.'),
            ),
            body: Container(
              color: Colors.blue,
              height: 60,
              child: Center(child: Text("Body")),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Container(height: 50, child: Center(child: Text("$index")));
          }, childCount: 50))
        ],
      ),
    ));
  }
}
