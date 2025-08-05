import Foundation

public struct CometChatBuilderSettings {
    
    public static var shared: BuilderStaticConfig = BuilderStaticConfig.defaultConfig()

        public static func loadFromJSON() {
            guard let url = Bundle.main.url(forResource: "cometchat-builder-settings", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let decoded = try? JSONDecoder().decode(BuilderWrapper.self, from: data)
            else {
                print("⚠️ Failed to load or decode \(fileName).json, using default settings.")
                return
            }
            
            shared = decoded.data.settings
            print("✅ CometChatBuilderSettings loaded from \(fileName).json")
        }
    
    private struct BuilderWrapper: Decodable {
        var data: BuilderData
    }
    
    private struct BuilderData: Decodable {
        var settings: BuilderStaticConfig
    }
}

// MARK: - Your Actual Config
public struct BuilderStaticConfig: Decodable {
    
    public var style: Style
    public var chatFeatures: ChatFeatures
    public var callFeatures: CallFeatures
    public var layout: Layout
    
    // Default fallback
    public static func defaultConfig() -> BuilderStaticConfig {
        return BuilderStaticConfig(
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
                    brandColor: "#6852D6",
                    primaryTextLight: "#141414",
                    primaryTextDark: "#FFFFFF",
                    secondaryTextLight: "#727272",
                    secondaryTextDark: "#989898"
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
                tabs: ["chats", "calls", "users", "groups"],
                chatType: "user"
            )
        }
    }
}
