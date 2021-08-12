import 'package:flutter/material.dart';
import 'package:profile_sliver/src/profile_sliver.dart';
import 'package:profile_sliver/src/profile_sliver_render_object.dart';

class ProfileSliverElement extends RenderObjectElement {
  Element? _header;
  Element? _body;

  ProfileSliverElement(ProfileSliver widget) : super(widget);

  @override
  ProfileSliver get widget => super.widget as ProfileSliver;

  @override
  void visitChildren(ElementVisitor visitor) {
    visitor(_body!);
    visitor(_header!);
  }

  /// remove the child
  @override
  void forgetChild(Element child) {
    if (child == _body) {
      _body = null;
      super.forgetChild(_body!);
    }
    if (child == _header) {
      _header = null;
      super.forgetChild(_header!);
    }
  }

  /// mount the child to the tree
  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _body = updateChild(_body, widget.body, 0);
    _header = updateChild(_header, widget.header, 1);
  }

  /// used when udpating a widget
  @override
  void update(ProfileSliver newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _body = updateChild(_body, widget.body, 0);
    _header = updateChild(_header, widget.header, 1);
  }

  /// insert a render object
  @override
  void insertRenderObjectChild(covariant RenderBox child, dynamic slot) {
    final ProfileSliverRenderObject renderObject =
        this.renderObject as ProfileSliverRenderObject;
    if (slot == 0) renderObject.body = child;
    if (slot == 1) renderObject.header = child;
    assert(renderObject == this.renderObject);
  }

  /// move a render object child
  @override
  void moveRenderObjectChild(
      covariant RenderObject child, dynamic oldSlot, dynamic newSlot) {
    assert(false);
  }

  /// remove render object child
  @override
  void removeRenderObjectChild(covariant RenderObject child, dynamic slot) {
    final ProfileSliverRenderObject renderObject =
        this.renderObject as ProfileSliverRenderObject;
    if (renderObject.body == child) renderObject.body = null;
    if (renderObject.header == child) renderObject.header = null;
    assert(renderObject == this.renderObject);
  }
}
