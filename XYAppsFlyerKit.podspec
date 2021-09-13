Pod::Spec.new do |s|
  s.name             = 'XYAppsFlyerKit'
  s.version          = '3.0.2'
  s.summary          = 'AppsFlyer的适配层'
  s.homepage         = 'https://github.com/QuVideoDeveloper/XYAppsFlyerKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Frenzy' => 'jialu.feng@quvideo.com' }
  s.source           = { :git => 'git@github.com:QuVideoDeveloper/XYAppsFlyerKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.source_files = 'XYAppsFlyerKit/Classes/**/*'

  s.dependency 'AppsFlyerFramework', '>= 6.2.5'
  s.dependency 'XYCategory'
  
end
