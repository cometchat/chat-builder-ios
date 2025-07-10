//
//  VCBStatic.swift
//  CometChatUIKitSwift
//
//  Created by Suryansh on 09/06/25.
//

public class VCBStatic {

    public class ChatFeatures {

        public class CoreMessagingExperience {
            public static var typingIndicator = true
            public static var threadConversationAndReplies = true
            public static var photosSharing = true
            public static var videosSharing = true
            public static var audioSharing = true
            public static var fileSharing = true
            public static var editMessage = true
            public static var deleteMessage = true
            public static var messageDeliveryAndReadReceipts = true
            public static var userAndFriendsPresence = true
        }

        public class DeeperUserEngagement {
            public static var mentions = true
            public static var reactions = true
            public static var messageTranslation = true
            public static var polls = true
            public static var collaborativeWhiteboard = true
            public static var collaborativeDocument = true
            public static var voiceNotes = true
            public static var emojis = true
            public static var stickers = true
            public static var userInfo = true
            public static var groupInfo = true
        }

        public class AiUserCopilot {
            public static var conversationStarter = true
            public static var conversationSummary = true
            public static var smartReply = true
        }

        public class GroupManagement {
            public static var createGroup = true
            public static var addMembersToGroups = true
            public static var joinLeaveGroup = true
            public static var deleteGroup = true
            public static var viewGroupMembers = true
        }

        public class ModeratorControls {
            public static var kickUsers = true
            public static var banUsers = true
            public static var promoteDemoteMembers = true
        }

        public class PrivateMessagingWithinGroups {
            public static var sendPrivateMessageToGroupMembers = true
        }
    }

    public class CallFeatures {

        public class VoiceAndVideoCalling {
            public static var oneOnOneVoiceCalling = true
            public static var oneOnOneVideoCalling = true
            public static var groupVideoConference = true
            public static var groupVoiceConference = true
        }
    }

    public class Layout {
        public static var withSideBar: Bool = true
        public static var tabs: [String] = ["chats", "calls", "users", "groups"]
        public static var chatType = "user"
    }

    public class Style {
        public static var theme = "system"

        public class Font {
            public static var font = "Arial"
            public static var fontSize = "default"
        }

        public class Color {
            public static var brandColor = "#6852D6"
            public static var primaryTextLight = "#141414"
            public static var primaryTextDark = "#FFFFFF"
            public static var secondaryTextLight = "#727272"
            public static var secondaryTextDark = "#989898"
        }
    }

    public class NoCode {
        public static var docked = false

        public class Styles {
            public static var buttonBackground = "#6952d6"
            public static var buttonShape = "rounded"
            public static var openIcon = "https://nocode-js.cometchat.io/v1/resources/docked_open_icon.svg"
            public static var closeIcon = "https://nocode-js.cometchat.io/v1/resources/docked_close_icon.svg"
            public static var customJS = ""
            public static var customCSS = ""
        }
    }
}
