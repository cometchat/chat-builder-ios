Pod::Spec.new do |s|
  s.name             = 'VCB'
  s.version          = '1.0.0'
  s.summary          = 'Visual Chat Builder iOS Module'
  s.description      = 'VCB lets you scan QR codes and quickly configure CometChat apps visually.'
  s.homepage         = 'https://github.com/cometchat-team/visual-chat-builder-app-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CometChat' => 'support@cometchat.com' }
  s.source           = { :git => 'https://github.com/cometchat-team/visual-chat-builder-app-ios.git', :tag => s.version }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/VCB/**/*.{swift,h}'
  s.resource_bundles = {
  'VCB' => ['Resources/**/*']
  }

  s.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7']
end
