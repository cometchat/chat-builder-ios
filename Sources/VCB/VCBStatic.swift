//
//  VCBStatic.swift
//  CometChatUIKitSwift
//
//  Created by Suryansh on 09/06/25.
//

//public class VCBStatic {
//
//    public class ChatFeatures {
//
//        public class CoreMessagingExperience {
//            public static var typingIndicator = true
//            public static var threadConversationAndReplies = true
//            public static var photosSharing = true
//            public static var videosSharing = true
//            public static var audioSharing = true
//            public static var fileSharing = true
//            public static var editMessage = true
//            public static var deleteMessage = true
//            public static var messageDeliveryAndReadReceipts = true
//            public static var userAndFriendsPresence = true
//        }
//
//        public class DeeperUserEngagement {
//            public static var mentions = true
//            public static var reactions = true
//            public static var messageTranslation = true
//            public static var polls = true
//            public static var collaborativeWhiteboard = true
//            public static var collaborativeDocument = true
//            public static var voiceNotes = true
//            public static var emojis = true
//            public static var stickers = true
//            public static var userInfo = true
//            public static var groupInfo = true
//        }
//
//        public class AiUserCopilot {
//            public static var conversationStarter = true
//            public static var conversationSummary = true
//            public static var smartReply = true
//        }
//
//        public class GroupManagement {
//            public static var createGroup = true
//            public static var addMembersToGroups = true
//            public static var joinLeaveGroup = true
//            public static var deleteGroup = true
//            public static var viewGroupMembers = true
//        }
//
//        public class ModeratorControls {
//            public static var kickUsers = true
//            public static var banUsers = true
//            public static var promoteDemoteMembers = true
//        }
//
//        public class PrivateMessagingWithinGroups {
//            public static var sendPrivateMessageToGroupMembers = true
//        }
//    }
//
//    public class CallFeatures {
//
//        public class VoiceAndVideoCalling {
//            public static var oneOnOneVoiceCalling = true
//            public static var oneOnOneVideoCalling = true
//            public static var groupVideoConference = true
//            public static var groupVoiceConference = true
//        }
//    }
//
//    public class Layout {
//        public static var withSideBar: Bool = true
//        public static var tabs: [String] = ["chats", "calls", "users", "groups"]
//        public static var chatType = "user"
//    }
//
//    public class Style {
//        public static var theme = "system"
//
//        public class Font {
//            public static var font = "Arial"
//            public static var fontSize = "default"
//        }
//
//        public class Color {
//            public static var brandColor = "#6852D6"
//            public static var primaryTextLight = "#141414"
//            public static var primaryTextDark = "#FFFFFF"
//            public static var secondaryTextLight = "#727272"
//            public static var secondaryTextDark = "#989898"
//        }
//    }
//
//    public class NoCode {
//        public static var docked = false
//
//        public class Styles {
//            public static var buttonBackground = "#6952d6"
//            public static var buttonShape = "rounded"
//            public static var openIcon = "https://nocode-js.cometchat.io/v1/resources/docked_open_icon.svg"
//            public static var closeIcon = "https://nocode-js.cometchat.io/v1/resources/docked_close_icon.svg"
//            public static var customJS = ""
//            public static var customCSS = ""
//        }
//    }
//}


import Foundation

public struct VCBStatic {
    
    public static let shared: VCBStaticConfig = {
        guard let url = Bundle.main.url(forResource: "vcb_config", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(VCBWrapper.self, from: data)
        else {
            print("⚠️ Failed to load or decode vcb_config.json, falling back to defaults.")
            return VCBStaticConfig.defaultConfig()
        }
        return decoded.data.settings
    }()
    
    // MARK: - Root Wrappers
    
    private struct VCBWrapper: Decodable {
        var data: VCBData
    }
    
    private struct VCBData: Decodable {
        var settings: VCBStaticConfig
    }
}

// MARK: - Your Actual Config
public struct VCBStaticConfig: Decodable {
    
    public var style: Style
    public var chatFeatures: ChatFeatures
    public var callFeatures: CallFeatures
    public var layout: Layout
    
    // Default fallback
    public static func defaultConfig() -> VCBStaticConfig {
        return VCBStaticConfig(
            style: Style.defaultStyle(),
            chatFeatures: ChatFeatures.defaultFeatures(),
            callFeatures: CallFeatures.defaultCalls(),
            layout: Layout.defaultLayout()
        )
    }
    
    // MARK: - Nested Types
    
    public struct Style: Decodable {
        public var theme: String
        public var color: Color
        public var typography: Typography
        
        public struct Color: Decodable {
            public var brandColor: String
            public var primaryTextLight: String
            public var primaryTextDark: String
            public var secondaryTextLight: String
            public var secondaryTextDark: String
        }
        
        public struct Typography: Decodable {
            public var font: String
            public var size: String
        }
        
        public static func defaultStyle() -> Style {
            return Style(
                theme: "light",
                color: Color(
                    brandColor: "#000000",
                    primaryTextLight: "#000000",
                    primaryTextDark: "#FFFFFF",
                    secondaryTextLight: "#AAAAAA",
                    secondaryTextDark: "#CCCCCC"
                ),
                typography: Typography(
                    font: "System",
                    size: "Default"
                )
            )
        }
    }
    
    public struct ChatFeatures: Decodable {
        public var coreMessagingExperience: CoreMessaging
        public var deeperUserEngagement: Engagement
        public var aiUserCopilot: Copilot
        public var groupManagement: Group
        public var moderatorControls: Moderator
        public var privateMessagingWithinGroups: PrivateMessaging
        
        public struct CoreMessaging: Decodable {
            public var typingIndicator: Bool
            public var threadConversationAndReplies: Bool
            public var photosSharing: Bool
            public var videoSharing: Bool
            public var audioSharing: Bool
            public var fileSharing: Bool
            public var editMessage: Bool
            public var deleteMessage: Bool
            public var messageDeliveryAndReadReceipts: Bool
            public var userAndFriendsPresence: Bool
        }
        
        public struct Engagement: Decodable {
            public var mentions: Bool
            public var reactions: Bool
            public var messageTranslation: Bool
            public var polls: Bool
            public var collaborativeWhiteboard: Bool
            public var collaborativeDocument: Bool
            public var voiceNotes: Bool
            public var emojis: Bool
            public var stickers: Bool
            public var userInfo: Bool
            public var groupInfo: Bool
        }
        
        public struct Copilot: Decodable {
            public var conversationStarter: Bool
            public var conversationSummary: Bool
            public var smartReply: Bool
        }
        
        public struct Group: Decodable {
            public var createGroup: Bool
            public var addMembersToGroups: Bool
            public var joinLeaveGroup: Bool
            public var deleteGroup: Bool
            public var viewGroupMembers: Bool
        }
        
        public struct Moderator: Decodable {
            public var kickUsers: Bool
            public var banUsers: Bool
            public var promoteDemoteMembers: Bool
        }
        
        public struct PrivateMessaging: Decodable {
            public var sendPrivateMessageToGroupMembers: Bool
        }
        
        public static func defaultFeatures() -> ChatFeatures {
            return ChatFeatures(
                coreMessagingExperience: CoreMessaging(
                    typingIndicator: true,
                    threadConversationAndReplies: true,
                    photosSharing: true,
                    videoSharing: true,
                    audioSharing: true,
                    fileSharing: true,
                    editMessage: true,
                    deleteMessage: true,
                    messageDeliveryAndReadReceipts: true,
                    userAndFriendsPresence: true
                ),
                deeperUserEngagement: Engagement(
                    mentions: true,
                    reactions: true,
                    messageTranslation: true,
                    polls: true,
                    collaborativeWhiteboard: true,
                    collaborativeDocument: true,
                    voiceNotes: true,
                    emojis: true,
                    stickers: true,
                    userInfo: true,
                    groupInfo: true
                ),
                aiUserCopilot: Copilot(
                    conversationStarter: true,
                    conversationSummary: true,
                    smartReply: true
                ),
                groupManagement: Group(
                    createGroup: true,
                    addMembersToGroups: true,
                    joinLeaveGroup: true,
                    deleteGroup: true,
                    viewGroupMembers: true
                ),
                moderatorControls: Moderator(
                    kickUsers: true,
                    banUsers: true,
                    promoteDemoteMembers: true
                ),
                privateMessagingWithinGroups: PrivateMessaging(
                    sendPrivateMessageToGroupMembers: true
                )
            )
        }
    }
    
    public struct CallFeatures: Decodable {
        public var voiceAndVideoCalling: VoiceVideo
        
        public struct VoiceVideo: Decodable {
            public var oneOnOneVoiceCalling: Bool
            public var oneOnOneVideoCalling: Bool
            public var groupVideoConference: Bool
            public var groupVoiceConference: Bool
        }
        
        public static func defaultCalls() -> CallFeatures {
            return CallFeatures(
                voiceAndVideoCalling: VoiceVideo(
                    oneOnOneVoiceCalling: true,
                    oneOnOneVideoCalling: true,
                    groupVideoConference: true,
                    groupVoiceConference: true
                )
            )
        }
    }
    
    public struct Layout: Decodable {
        public var withSideBar: Bool
        public var tabs: [String]
        public var chatType: String
        
        public static func defaultLayout() -> Layout {
            return Layout(
                withSideBar: true,
                tabs: ["chats", "users"],
                chatType: "user"
            )
        }
    }
}
