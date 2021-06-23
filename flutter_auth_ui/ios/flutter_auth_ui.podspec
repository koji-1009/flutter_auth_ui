#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_auth_ui.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_auth_ui'
  s.version          = '2.2.0'
  s.summary          = 'Unofficial firebaseui package for flutter. This library aims to provide support for Android, iOS and the web. Login with Email, Phone, Google account and etc.'
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

  s.dependency 'FirebaseUI/Auth', '~> 11.0'
  s.dependency 'FirebaseUI/Anonymous', '~> 11.0'
  s.dependency 'FirebaseUI/Email', '~> 11.0'
  s.dependency 'FirebaseUI/Facebook', '~> 11.0'
  s.dependency 'FirebaseUI/Google', '~> 11.0'
  s.dependency 'FirebaseUI/OAuth', '~> 11.0'
  s.dependency 'FirebaseUI/Phone', '~> 11.0'

  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
