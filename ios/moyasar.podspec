#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint moyasar.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'moyasar'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plug-in to integrate Moyasar payment gateway'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'm.elsheikh@mylabaih.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.dependency 'MoyasarSdk'
  s.resource_bundles = {
      'moyasar' => ['SDK/*/*.{xib,storyboard,xcassets}']
  }
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
