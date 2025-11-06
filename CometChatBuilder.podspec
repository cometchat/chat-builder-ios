Pod::Spec.new do |s|
  s.name             = 'CometChatBuilder'
  s.version          = '1.1.1'
  s.summary          = 'Chat builder component for CometChat iOS SDK'
  s.description      = 'A Swift library to power your low-code and no-code chat UI for CometChat.'

  s.homepage         = 'https://www.cometchat.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dawinderkaur' => 'dawinder.kaur@cometchat.com' }
  s.source           = { :git => 'https://github.com/cometchat/chat-builder-ios.git', :tag => s.version }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'

s.source_files = 'Sources/CometChatBuilder/**/*.{swift}'

s.resource_bundles = {
  'CometChatBuilder' => ['Resources/CometChatBuilderAssets.xcassets']
}

  
end
