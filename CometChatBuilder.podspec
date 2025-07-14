Pod::Spec.new do |s|
  s.name             = 'CometChatBuilder'
  s.version          = '1.0.0'
  s.summary          = 'CometChatBuilder SDK'
  s.description      = 'A Swift library to power your low-code and no-code chat UI for CometChat.'

  s.homepage         = 'https://www.cometchat.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dawinderkaur' => 'dawinder.kaur@cometchat.com' }

  s.platform     = :ios, '13.0'
  s.source       = { :git => 'https://github.com/cometchat-team/visual-chat-builder-app-ios.git', :tag => s.version }
  s.source_files  = 'Sources/CometChatBuilder/**/*.{swift}'
  s.resources     = 'Resources/CometChatBuilderAssets.xcassets'

  s.swift_version = '5.0'
end
