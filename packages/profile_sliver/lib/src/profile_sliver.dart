import 'package:flutter/cupertino.dart';
import 'package:profile_sliver/src/profile_sliver_element.dart';
import 'package:profile_sliver/src/profile_sliver_render_object.dart';

class ProfileSliver extends RenderObjectWidget {
  final Widget header;
  final Widget body;
  final double headerHeight;

  const ProfileSliver({
    Key? key,
    required this.header,
    required this.body,
    required this.headerHeight,
  }) : super(key: key);

  @override
  ProfileSliverElement createElement() => ProfileSliverElement(this);

  /// create a render object instance of the profile sliver
  @override
  ProfileSliverRenderObject createRenderObject(BuildContext context) {
    return ProfileSliverRenderObject(headerHeight: headerHeight);
  }

  @override
  void updateRenderObject(
      BuildContext context, ProfileSliverRenderObject renderObject) {
    renderObject..headerHeight = headerHeight;
  }
}
