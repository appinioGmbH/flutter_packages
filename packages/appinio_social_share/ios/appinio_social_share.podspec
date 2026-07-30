#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appinio_social_share.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appinio_social_share'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  # Shared with the Swift Package Manager target — single source of truth.
  s.source_files = 'appinio_social_share/Sources/appinio_social_share/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'FBSDKCoreKit', '17.0.2'
  s.dependency 'FBSDKShareKit', '17.0.2'
  s.static_framework = true

  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
