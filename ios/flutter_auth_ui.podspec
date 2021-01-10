#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_auth_ui.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_auth_ui'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for using the Firebase Auth UI with Dart in Flutter apps.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/koji-1009/flutter_auth_ui'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Koji Wakamiya' => 'koji.wakamiya@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  
  s.static_framework = true
  s.dependency 'FirebaseUI/Auth', '~> 9.0'
  s.dependency 'FirebaseUI/Email', '~> 9.0'
  s.dependency 'FirebaseUI/Google', '~> 9.0'
  s.dependency 'FirebaseUI/Facebook', '~> 9.0'
  s.dependency 'FirebaseUI/Phone', '~> 9.0'
  s.dependency 'FirebaseUI/OAuth', '~> 9.0'
  
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
