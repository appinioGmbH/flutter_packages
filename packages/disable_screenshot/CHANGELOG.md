## 0.0.2

* Added iOS Swift Package Manager (SwiftPM) support via `ios/disable_screenshot/Package.swift`.
* Unified the iOS sources under `ios/disable_screenshot/Sources` (single source of truth); the podspec now points there and the legacy `ios/Classes` Objective-C shim was removed. The plugin is now pure Swift on iOS and builds under both CocoaPods and SwiftPM.

## 0.0.1

* TODO: Describe initial release.
