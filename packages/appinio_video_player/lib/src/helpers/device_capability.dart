import 'package:flutter/foundation.dart';

import 'device_capability_stub.dart'
    if (dart.library.io) 'device_capability_io.dart' as _cap;

/// Device capability helpers (e.g. for choosing progress update rate on low-end devices).
abstract final class DeviceCapability {
  DeviceCapability._();

  static int get _processorCount => _cap.processorCount;

  /// Default interval for progress updates (smooth UI).
  static const Duration defaultProgressUpdateInterval =
      Duration(milliseconds: 100);

  /// Slower interval used when [useSlowerProgressOnLowEndDevices] is true on low-end devices.
  static const Duration slowProgressUpdateInterval =
      Duration(milliseconds: 250);

  /// Threshold: devices with this many cores or fewer are treated as low-end for progress updates.
  static const int lowEndProcessorCountThreshold = 4;

  /// Returns a progress-update interval suitable for the current device.
  /// On web or devices with more than [lowEndProcessorCountThreshold] cores, returns [defaultProgressUpdateInterval].
  /// On low-end devices (e.g. 4 or fewer cores), returns [slowProgressUpdateInterval] to reduce jank/freezes.
  static Duration get recommendedProgressUpdateIntervalForDevice {
    if (kIsWeb) return defaultProgressUpdateInterval;
    return _processorCount <= lowEndProcessorCountThreshold
        ? slowProgressUpdateInterval
        : defaultProgressUpdateInterval;
  }
}
