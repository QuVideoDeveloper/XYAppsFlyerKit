Pod::Spec.new do |s|
  s.name             = 'XYAppsFlyerKit'
  s.version          = '1.0.0'
  s.summary          = 'AppsFlyer的适配层'
  s.homepage         = 'https://github.com/QuVideoDeveloper/XYAppsFlyerKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Frenzy' => 'jialu.feng@quvideo.com' }
  s.source           = { :git => 'https://github.com/QuVideoDeveloper/XYAppsFlyerKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'XYAppsFlyerKit/Classes/**/*'

  s.dependency 'AppsFlyerFramework', '~>6.2.2'
  s.dependency 'XYCategory'
  
end
