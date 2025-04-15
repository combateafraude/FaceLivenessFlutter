#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint face_liveness.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_caf_face_liveness'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for Caf.io solution for facial verification.'
  s.description      = <<-DESC
This plugin uses smart cameras to capture reliable selfies of your users with artificial intelligence, detecting and rejecting photo and video spoofing attempts. It's ideal for secure and seamless onboarding processes.
                       DESC
  s.homepage         = 'https://www.caf.io/'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Caf.io' => 'services@caf.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platform = :ios, '13.0'
  
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.3.2'
  s.dependency 'Flutter'
  s.dependency 'FaceLiveness', '7.2.1'
  # Add static framework? s.static_framework = true
end
