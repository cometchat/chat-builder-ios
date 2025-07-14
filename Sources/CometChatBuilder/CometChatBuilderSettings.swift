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
