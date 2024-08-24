import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'
    if (dart.library.js) "package:flutter/material.dart";

import 'disable_screenshot_platform_interface.dart';

/// An implementation of [DisableScreenshotPlatform] that uses method channels.
class MethodChannelDisableScreenshot extends DisableScreenshotPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('disable_screenshot');
  final MethodChannel _methodChannel =
      const MethodChannel("com.appinio.screenshot/disableScreenshots");
  final EventChannel _eventChannel =
      const EventChannel('com.appinio.screenshot/observer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Stream<void>? _onScreenShots;

  @override
  Stream<void> onScreenShots() {
    _onScreenShots ??= _eventChannel.receiveBroadcastStream();
    return _onScreenShots!;
  }

  @override
  Future<void> disableScreenshots(bool disable) async {
    if (Platform.isAndroid) {
      return await _methodChannel.invokeMethod("disableScreenshots", disable);
    } else {
      // print('Disabling screenshots is only supported on Android');
    }
  }

  @override
  Future<String?> captureScreenShot({
    required GlobalKey screenshotWidgetKey,
    String name = 'screenshot',
  }) async {
    try {
      RenderRepaintBoundary boundary = screenshotWidgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3);
      String directory = !kIsWeb
          ? (await getApplicationDocumentsDirectory()).path
          : '/assets/db';

      ByteData? byteData =
          await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        var pngBytes = byteData.buffer.asUint8List();
        File imgFile = File('$directory/$name.png');
        await imgFile.writeAsBytes(pngBytes);
        return '$directory/$name.png';
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<String?> captureScreenShotFromWidget(Widget widget,
      {Duration delay = const Duration(milliseconds: 50),
      double? pixelRatio,
      BuildContext? context,
      String? filename}) async {
    ///
    ///Retry counter
    ///
    int retryCounter = 3;
    bool isDirty = false;

    Widget child = widget;

    if (context != null) {
      ///
      ///Inherit Theme and MediaQuery of app
      ///
      ///
      child = InheritedTheme.captureAll(
        context,
        MediaQuery(data: MediaQuery.of(context), child: child),
      );
    }

    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    final contextViewConfiguration =
        ViewConfiguration.fromView(View.of(context!));

    final RenderView renderView = RenderView(
      view: View.of(context),
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        logicalConstraints: contextViewConfiguration.logicalConstraints,
        physicalConstraints: contextViewConfiguration.physicalConstraints,
        devicePixelRatio: pixelRatio ?? 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(
        focusManager: FocusManager(),
        onBuildScheduled: () {
          ///
          ///current render is dirty, mark it.
          ///
          isDirty = true;
        });

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
            container: repaintBoundary,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: child,
            )).attachToRenderTree(
      buildOwner,
    );
    ////
    ///Render Widget
    ///
    ///

    buildOwner.buildScope(
      rootElement,
    );
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image? image;

    do {
      ///
      ///Reset the dirty flag
      ///
      ///
      isDirty = false;

      image = await repaintBoundary.toImage(
        pixelRatio: pixelRatio ?? contextViewConfiguration.devicePixelRatio,
      );

      ///
      ///This delay shoud inceases with Widget tree Size
      ///

      await Future.delayed(delay);

      ///
      ///Check does this require rebuild
      ///
      ///
      if (isDirty) {
        ///
        ///Previous capture has been updated, re-render again.
        ///
        ///
        buildOwner.buildScope(
          rootElement,
        );
        buildOwner.finalizeTree();
        pipelineOwner.flushLayout();
        pipelineOwner.flushCompositingBits();
        pipelineOwner.flushPaint();
      }
      retryCounter--;

      ///
      ///retry untill capture is successfull
      ///
    } while (isDirty && retryCounter >= 0);

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    String directory = !kIsWeb
        ? (await getApplicationDocumentsDirectory()).path
        : '/assets/db';
    await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      var pngBytes = byteData.buffer.asUint8List();
      String path = '$directory/screenshot${filename ?? ""}.png';
      File imgFile = File(path);
      await imgFile.writeAsBytes(pngBytes);
      return path;
    } else {
      return null;
    }
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
