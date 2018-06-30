Pod::Spec.new do |s|
  s.name             = 'RLBCardsLayout'
  s.version          = '0.1.0'
  s.summary          = 'A UICollectionViewLayout subclass imitating flipping cards'
  s.swift_version    = '4.0'


  s.homepage         = 'https://github.com/rcbello/RLBCardsLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'rcbello' => 'riadhluke@gmail.com' }
  s.source           = { :git => 'https://github.com/rcbello/RLBCardsLayout.git', :tag => '0.1.0' }
  s.ios.deployment_target = '8.0'
  s.source_files = 'RLBCardsLayout/*'
end

