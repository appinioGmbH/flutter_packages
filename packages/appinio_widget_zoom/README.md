The `AppinioZoomWidget` is lightweight widget to make your images zoomable.

A simple tap lets you animate this image into fullscreen and zoom around there. You can either hit the close button or swipe down to dismiss the fullscreen again. Just as you know from other apps.

## Features

- Directly use pinch to zoom gesture on the image
- Open tapped image in fullscreen
- Zoom and pan around in fullscreen view
- Double tap to zoom in/out in fullscreen view
- Swipe down to dismiss the fullscreen view

## Getting started

Just wrap your image widget that should be zoomable with the `ZoomWidget` and pass an object for the `heroAnimationTag` parameter and you are good to go. (The Hero animation is there to provide you with a nice transition when entering and leaving the fullscreen by tapping your image)

## Usage

It doesn't need more setup than this:

```dart
 ZoomWidget(
    heroAnimationTag: 'tag',
    zoomWidget: Image.network(
        'https://i.picsum.photos/id/1076/1000/800.jpg?hmac=Dlz3UOB04NkIUuAcoyNPNP_uRbjWK9FSoHfy4i04yWI',
    ),
),
```

<hr/>Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
