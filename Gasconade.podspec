Pod::Spec.new do |s|
  s.platform               = :ios
  s.ios.deployment_target  = '8.0'
  s.name                   = 'Fotofan'
  s.summary                = 'Netcosports fotofan'
  s.requires_arc           = true

  s.version          = '0.6.13'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.description      = <<-DESC
Netcosports fotofan. TBD
                       DESC

  s.author           = { 'Dmitry Duleba' => 'dmitry.duleba@netcosports.com', 'Alexey Zhemblovskiy' => 'alexey.zhemblovski@netcosports.com' }

  s.homepage         = 'https://github.com/netcosports/Fotofan'
  
  s.source           = { :git => 'https://github.com/netcosports/Fotofan.git', :tag => s.version.to_s }

  s.dependency 'GPUImage', '0.1.7'
  s.dependency 'SnapKit', '~> 3'

  s.framework = "UIKit"
  s.framework = "Foundation"
  s.framework = "AVFoundation"
  s.framework = "CoreMedia"
  s.framework = "CoreImage"
  s.framework = "Photos"

  s.source_files = 'Fotofan/Classes/**/*.{swift}'

  s.resources = 'Fotofan/*.{bundle}'
end
