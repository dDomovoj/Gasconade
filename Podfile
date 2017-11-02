platform :ios, '9.0'
use_frameworks!

target 'GameConnect' do
  pod 'SwiftyTimer'
  pod 'Masonry'
  pod 'UICountingLabel'
  pod 'SnapKit', '~> 3.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '3.2'
    end
  end
end
