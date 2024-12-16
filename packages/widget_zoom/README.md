The `WidgetZoom` enables you to zoom on your images.

Either zoom directly on the image with a pinch to zoom gesture or use a simple tap to open the image in fullscreen and zoom around there. You can either hit the close button or swipe down to dismiss the fullscreen again. Just as you know from other apps.

## Why?

We build this package because we wanted to:

- have a simple and easy way to use zoom on images for users
- integrate a lightweight package
- create an easy usage experience for developers

## Show Case

## Pinch to zoom

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/widget_zoom/pinch_to_zoom.gif?raw=true" height="400">

## Drag down to exit fullscreen

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/widget_zoom/swipe_to_exit.gif?raw=true" height="400">

## Zoom flutter widgets

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/widget_zoom/zoom_widget.gif?raw=true" height="400">

## Features

- Directly use pinch to zoom gesture on the image
- Open tapped image in fullscreen
- Zoom and pan around in fullscreen view
- Double tap to zoom in/out in fullscreen view
- Swipe down to dismiss the fullscreen view
- Coming soon: zoom on any widget you like

## Getting started

Just wrap your image widget that should be zoomable with the `WidgetZoom` and pass an object for the `heroAnimationTag` parameter and you are good to go. (The Hero animation is there to provide you with a nice transition when entering and leaving the fullscreen by tapping your image)

## Usage

It doesn't need more setup than this:

```dart
 WidgetZoom(
    heroAnimationTag: 'tag',
    zoomWidget: Image.network(
        'https://i.picsum.photos/id/1076/1000/800.jpg?hmac=Dlz3UOB04NkIUuAcoyNPNP_uRbjWK9FSoHfy4i04yWI',
    ),
),
```

## Constructor

| Parameter                     | Default              | Description                                                                        | Required |
| ----------------------------  | :------------------- | :--------------------------------------------------------------------------------- | :------: |
| zoomWidget                    | -                    | The widget that should be zoomable                                                 |   true   |
| heroAnimationTag              | -                    | An object used for the Hero animation when navigating to and from fullscreen       |   true   |
| minScaleEmbeddedView          | 1                    | The smallest allowed scale when zooming the widget not in fullscreen               |  false   |
| maxScaleEmbeddedView          | 4                    | The highest allowed scale when zooming the widget not in fullscreen                |  false   |
| minScaleFullscreen            | 1                    | The smallest allowed scale when zooming the widget in fullscreen                   |  false   |
| maxScaleFullscreen            | 4                    | The highest allowed scale when zooming the widget in fullscreen                    |  false   |
| fullScreenDoubleTapZoomScale  | maxScaleFullscreen   | The zoom scale when double tapping the zoomable widget in fullscreen               |  false   |
| closeFullScreenImageOnDispose | false                | Controls whether the full screen image will be closed once the widget is disposed. |  false   |
| closeIcon                     | CupertinoIcons.xmark | Widget displayed at the top right corner of the full screen image that closes it.  |  false   |


<hr/>Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
