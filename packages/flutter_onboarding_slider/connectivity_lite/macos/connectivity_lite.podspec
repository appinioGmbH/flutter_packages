#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint connectivity_lite.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'connectivity_lite'
  s.version          = '0.0.1'
  s.summary          = 'A package to check internet connection and listen to internet state change'
  s.description      = <<-DESC
A package to check internet connection and listen to internet state change
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
