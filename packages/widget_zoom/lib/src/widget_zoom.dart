import 'package:flutter/material.dart';
import 'package:widget_zoom/src/widget_zoom_full_screen.dart';

class WidgetZoom extends StatefulWidget {
  /// The widget that should be zoomed.
  final Widget zoomWidget;

  /// The minimal scale that is allowed for this widget to be zoomed to.
  final double minScaleEmbeddedView;

  /// The maximal scale that is allowed for this widget to be zoomed to.
  final double maxScaleEmbeddedView;

  /// min scale for the widget in fullscreen
  final double minScaleFullscreen;

  /// max scale for the widget in fullscreen
  final double maxScaleFullscreen;

  /// if not specified the [maxScaleFullscreen] is used
  final double? fullScreenDoubleTapZoomScale;

  /// provide custom hero animation tag and make sure every [WidgetZoom] in your subtree uses a different tag. otherwise the animation doesnt work
  final Object heroAnimationTag;

  /// Controls whether the full screen image will be closed once the widget is disposed.
  final bool closeFullScreenImageOnDispose;

  /// Widget displayed at the top right corner of the full screen image. Closes the overlay when tapped.
  /// If not specified, [CupertinoIcons.xmark] will be displayed in white color.
  final Widget? closeIcon;

  const WidgetZoom({
    Key? key,
    this.minScaleEmbeddedView = 1,
    this.maxScaleEmbeddedView = 4,
    this.minScaleFullscreen = 1,
    this.maxScaleFullscreen = 4,
    this.fullScreenDoubleTapZoomScale,
    this.closeFullScreenImageOnDispose = false,
    required this.heroAnimationTag,
    required this.zoomWidget,
    this.closeIcon,
  }) : super(key: key);

  @override
  State<WidgetZoom> createState() => _WidgetZoomState();
}

class _WidgetZoomState extends State<WidgetZoom>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _animationController;
  late double _scale = widget.minScaleEmbeddedView;
  Animation<Matrix4>? _animation;
  OverlayEntry? _entry;
  Duration _opcaityBackgroundDuration = Duration.zero;
  bool _isFullScreenImageOpened = false;

  late NavigatorState _rootNavigator;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )
      ..addListener(() => _transformationController.value = _animation!.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _removeOverlay();
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rootNavigator = Navigator.of(context, rootNavigator: true);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    _removeOverlay();
    _closeFullScreenImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openImageFullscreen(),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    return Builder(
      builder: (context) {
        return InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: false,
          clipBehavior: Clip.none,
          minScale: widget.minScaleEmbeddedView,
          maxScale: widget.maxScaleEmbeddedView,
          onInteractionStart: _showOverlay,
          onInteractionUpdate: _onInteractionUpdate,
          onInteractionEnd: (details) => _resetAnimation(),
          child: Hero(
            tag: widget.heroAnimationTag,
            child: widget.zoomWidget,
          ),
        );
      },
    );
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    if (_entry != null) {
      _scale = details.scale;
      _entry?.markNeedsBuild();
    }
  }

  void _showOverlay(ScaleStartDetails details) {
    if (details.pointerCount > 1) {
      _removeOverlay();
      final RenderBox imageBox = context.findRenderObject() as RenderBox;
      final Offset imageOffset = imageBox.localToGlobal(Offset.zero);
      _entry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                duration: _opcaityBackgroundDuration,
                opacity: ((_scale - 1) / (widget.maxScaleEmbeddedView - 1))
                    .clamp(0, 1)
                    .toDouble(),
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              left: imageOffset.dx,
              top: imageOffset.dy,
              width: imageBox.size.width,
              height: imageBox.size.height,
              child: _buildImage(),
            ),
          ],
        ),
      );

      final OverlayState overlay = Overlay.of(context);
      overlay.insert(_entry!);
    }
  }

  void _removeOverlay() {
    _opcaityBackgroundDuration = Duration.zero;
    _entry?.remove();
    _entry = null;
  }

  void _resetAnimation() {
    _opcaityBackgroundDuration =
        _animationController.duration ?? const Duration(milliseconds: 300);
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward(from: 0);
  }

  Future<void> _openImageFullscreen() async {
    _isFullScreenImageOpened = true;
    await _rootNavigator.push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation1, animation2) => FadeTransition(
          opacity: animation1,
          child: WidgetZoomFullscreen(
            zoomWidget: widget.zoomWidget is Image
                ? Image(
                    image: (widget.zoomWidget as Image).image,
                    fit: BoxFit.contain,
                  )
                : widget.zoomWidget,
            minScale: widget.minScaleFullscreen,
            maxScale: widget.maxScaleFullscreen,
            heroAnimationTag: widget.heroAnimationTag,
            fullScreenDoubleTapZoomScale: widget.fullScreenDoubleTapZoomScale,
            closeIcon: widget.closeIcon,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
    _isFullScreenImageOpened = false;
  }

  void _closeFullScreenImage() {
    if (_isFullScreenImageOpened && _rootNavigator.canPop()) {
      _rootNavigator.pop();
    }
  }
}
