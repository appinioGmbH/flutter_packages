import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class ProfileSliverRenderObject extends RenderSliver with RenderSliverHelpers {
  late double _headerHeight;
  RenderBox? _body;
  RenderBox? _header;

  ProfileSliverRenderObject({
    RenderBox? body,
    RenderBox? header,
    required headerHeight,
  }) {
    _headerHeight = headerHeight;
    if (body != null) this.body = body;
    if (header != null) this.header = header;
  }

  /// return the height of the entire height of the header
  double get mainHeight => bodyExtent + headerHeight;

  /// return whether the header is being streched
  bool get isStretching => scrollOffset <= 0;

  /// get the scrolloffset that includes the overlapped area
  double get scrollOffset => constraints.scrollOffset + constraints.overlap;

  /// get the height of the header
  double get headerHeight => _headerHeight;
  set headerHeight(double value) {
    if (headerHeight == value) return;
    headerHeight = value;
    markNeedsLayout();
  }

  /// get the height of the body
  double get bodyExtent {
    if (body == null) {
      return 0.0;
    }
    assert(body!.hasSize);
    assert(constraints.axis == Axis.vertical);
    return body!.size.height;
  }

  /// get the height of the background
  double get backgroundExtent {
    if (header == null) {
      return 0.0;
    }
    assert(header!.hasSize);
    assert(constraints.axis == Axis.vertical);
    return header!.size.height;
  }

  RenderBox? get body => _body;
  set body(RenderBox? value) {
    if (_body != null) dropChild(_body!);
    _body = value;
    if (_body != null) adoptChild(_body!);
  }

  RenderBox? get header => _header;
  set header(RenderBox? value) {
    if (_header != null) dropChild(_header!);
    _header = value;
    if (_header != null) adoptChild(_header!);
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    if (body != null) body!.attach(owner);
    if (header != null) header!.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (body != null) body!.detach();
    if (header != null) header!.detach();
  }

  @override
  void redepthChildren() {
    super.redepthChildren();
    if (body != null) redepthChild(body!);
    if (header != null) redepthChild(header!);
  }

  @override
  void visitChildren(void Function(RenderObject child) visitor) {
    super.visitChildren(visitor);
    if (body != null) visitor(body!);
    if (header != null) visitor(header!);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (body != null) result.add(body!.toDiagnosticsNode(name: 'body'));
    if (body != null) result.add(header!.toDiagnosticsNode(name: 'background'));
    return result;
  }

  @override
  void performLayout() {
    if (body == null || header == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    body!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    double stretchOffset = 0.0;
    if (constraints.overlap < 0) {
      stretchOffset = constraints.overlap.abs();
    }
    final backgroundExtent =
        isStretching ? mainHeight + stretchOffset : mainHeight;
    header!.layout(
      constraints.asBoxConstraints(
          maxExtent: backgroundExtent, minExtent: backgroundExtent),
      parentUsesSize: true,
    );

    if (isStretching) {
      final double effectiveRemainingPaintExtent =
          math.max(0, constraints.remainingPaintExtent - constraints.overlap);
      final double layoutExtent =
          (mainHeight - constraints.precedingScrollExtent)
              .clamp(0.0, effectiveRemainingPaintExtent);
      final double paintExtent =
          (backgroundExtent - constraints.precedingScrollExtent)
              .clamp(0.0, effectiveRemainingPaintExtent);
      geometry = SliverGeometry(
        scrollExtent: backgroundExtent,
        paintOrigin: math.min(constraints.overlap, 0.0),
        paintExtent: paintExtent,
        layoutExtent: layoutExtent,
        maxPaintExtent: paintExtent,
        cacheExtent: backgroundExtent,
        hitTestExtent: backgroundExtent,
        maxScrollObstructionExtent: 0.0,
        hasVisualOverflow: true,
      );
    } else {
      final paintedBackgroundExtent =
          math.max(0.0, backgroundExtent - constraints.precedingScrollExtent);
      final double paintedBackgroundSize = calculatePaintOffset(constraints,
          from: 0.0, to: paintedBackgroundExtent);
      final double cacheExtent =
          calculateCacheOffset(constraints, from: 0.0, to: backgroundExtent);

      assert(paintedBackgroundSize.isFinite);
      assert(paintedBackgroundSize >= 0.0);
      geometry = SliverGeometry(
        scrollExtent: backgroundExtent,
        paintExtent: paintedBackgroundSize,
        cacheExtent: cacheExtent,
        layoutExtent: paintedBackgroundSize,
        maxPaintExtent: paintedBackgroundSize,
        hitTestExtent: backgroundExtent,
        hasVisualOverflow:
            backgroundExtent > constraints.remainingPaintExtent ||
                scrollOffset > 0.0,
      );
    }
  }

  /// change the position
  @override
  double childMainAxisPosition(covariant RenderObject child) {
    final double offset = isStretching ? 0 : -constraints.scrollOffset;
    final double originY = offset - constraints.precedingScrollExtent;
    if (child == this.header) {
      return originY;
    }

    if (child == this.body) {
      final double blankExtent = backgroundExtent - bodyExtent;
      return originY + blankExtent;
    }
    return 0.0;
  }

  /// hit text logic
  @override
  bool hitTest(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    assert(geometry!.hitTestExtent > constraints.precedingScrollExtent);
    if (mainAxisPosition >= -constraints.precedingScrollExtent &&
        mainAxisPosition <
            geometry!.hitTestExtent - constraints.precedingScrollExtent &&
        crossAxisPosition >= 0.0 &&
        crossAxisPosition < constraints.crossAxisExtent) {
      if (hitTestChildren(result,
              mainAxisPosition: mainAxisPosition,
              crossAxisPosition: crossAxisPosition) ||
          hitTestSelf(
              mainAxisPosition: mainAxisPosition,
              crossAxisPosition: crossAxisPosition)) {
        result.add(SliverHitTestEntry(
          this,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        ));
        return true;
      }
    }
    return false;
  }

  /// adapt hit test logic to children
  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    assert(geometry!.hitTestExtent > 0.0);
    if (body != null) {
      final bool isHit = hitTestBoxChild(BoxHitTestResult.wrap(result), body!,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition);
      if (isHit) return true;
    }
    if (header != null) {
      final bool isHitHere = hitTestBoxChild(
          BoxHitTestResult.wrap(result), header!,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition);
      if (isHitHere) return true;
    }
    return false;
  }

  /// get the child scroll offset
  @override
  double? childScrollOffset(covariant RenderObject child) {
    assert(child.parent == this);
    if (child == this.body) {
      return backgroundExtent - bodyExtent;
    } else {
      return super.childScrollOffset(child);
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }

  /// paint
  @override
  void paint(PaintingContext context, Offset offset) {
    if (geometry!.visible) {
      assert(constraints.axisDirection == AxisDirection.down);
      if (header != null)
        context.paintChild(
            header!, offset + Offset(0.0, childMainAxisPosition(header!)));
      if (body != null)
        context.paintChild(
            body!, offset + Offset(0.0, childMainAxisPosition(body!)));
    }
  }

  /// debug fill properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DoubleProperty.lazy('minimum stretch extent', () => headerHeight));
    properties.add(DoubleProperty.lazy(
        'child position', () => childMainAxisPosition(body!)));
  }
}
