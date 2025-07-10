Pod::Spec.new do |s|
  s.name         = "VCB"
  s.version      = "1.0.0"
  s.summary      = "Visual Chat Builder"
  s.description  = "Visual Chat Builder module for CometChat"
  s.homepage     = "https://github.com/cometchat-team/visual-chat-builder-app-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "CometChat" => "support@cometchat.com" }

  s.source       = { :git => "https://github.com/cometchat-team/visual-chat-builder-app-ios.git", :tag => s.version.to_s }

  s.ios.deployment_target = "13.0"
  s.source_files  = "Sources/VCB/**/*.{swift}"
  s.resources     = "Resources/**/*"
end

