// VM/IO: use actual processor count for low-end device detection.

import 'dart:io' show Platform;

int get processorCount => Platform.numberOfProcessors;
