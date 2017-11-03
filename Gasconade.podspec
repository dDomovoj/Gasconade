Pod::Spec.new do |s|
  s.platform               = :ios
  s.ios.deployment_target  = '9.0'
  s.name                   = 'Gasconade'
  s.summary                = 'Netcosports Gasconade'
  s.requires_arc           = true

  s.version          = '0.0.1'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.description      = <<-DESC
Netcosports Gasconade. TBD
                       DESC

  s.author           = { 'Dmitry Duleba' => 'dmitry.duleba@netcosports.com' }
  s.homepage         = 'https://github.com/dDomovoj/Gasconade'
  s.source           = { :git => 'https://github.com/dDomovoj/Gasconade.git', :tag => s.version.to_s }

  s.dependency 'SnapKit', '~> 3.0'
  s.dependency 'SwiftyTimer'
  s.dependency 'Masonry'
  s.dependency 'UICountingLabel'
  s.dependency 'SDWebImage'

  s.framework = "UIKit"
  s.framework = "Foundation"
  s.framework = "CoreText"

  s.source_files = 'GameConnect/Source/**/*.{swift,m,h}'

  # s.resources = 'Fotofan/*.{bundle}'
end
