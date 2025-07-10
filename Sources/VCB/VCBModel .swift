//
//  VCB Model .swift
//  CometChatUIKitSwift
//
//  Created by Suryansh on 09/06/25.
//

// MARK: - Full API Response

public struct APIResponse: Decodable {
    public let data: DataContainer

    public struct DataContainer: Decodable {
        public let settings: Settings
    }
}

// MARK: - Settings

public struct Settings: Decodable {
    public let chatFeatures: ChatFeatures
    public let callFeatures: CallFeatures
    public let layout: Layout
    public let style: Style
    public let noCode: NoCode
}

// MARK: - Style

public struct Style: Decodable {
    public let theme: String
    public let color: Color
    public let typography: Typography

    public struct Color: Decodable {
        public let brandColor: String
        public let primaryTextLight: String
        public let primaryTextDark: String
        public let secondaryTextLight: String
        public let secondaryTextDark: String
    }

    public struct Typography: Decodable {
        public let font: String
        public let size: String
    }
}

// MARK: - Chat Features

public struct ChatFeatures: Decodable {
    public let coreMessagingExperience: CoreMessagingExperience
    public let deeperUserEngagement: DeeperUserEngagement
    public let aiUserCopilot: AiUserCopilot
    public let groupManagement: GroupManagement
    public let moderatorControls: ModeratorControls
    public let privateMessagingWithinGroups: PrivateMessagingWithinGroups

    public struct CoreMessagingExperience: Decodable {
        public let typingIndicator: Bool
        public let threadConversationAndReplies: Bool
        public let photosSharing: Bool
        public let videoSharing: Bool
        public let audioSharing: Bool
        public let fileSharing: Bool
        public let editMessage: Bool
        public let deleteMessage: Bool
        public let messageDeliveryAndReadReceipts: Bool
        public let userAndFriendsPresence: Bool
    }

    public struct DeeperUserEngagement: Decodable {
        public let mentions: Bool
        public let reactions: Bool
        public let messageTranslation: Bool
        public let polls: Bool
        public let collaborativeWhiteboard: Bool
        public let collaborativeDocument: Bool
        public let voiceNotes: Bool
        public let emojis: Bool
        public let stickers: Bool
        public let userInfo: Bool
        public let groupInfo: Bool
    }

    public struct AiUserCopilot: Decodable {
        public let conversationStarter: Bool
        public let conversationSummary: Bool
        public let smartReply: Bool
    }

    public struct GroupManagement: Decodable {
        public let createGroup: Bool
        public let addMembersToGroups: Bool
        public let joinLeaveGroup: Bool
        public let deleteGroup: Bool
        public let viewGroupMembers: Bool
    }

    public struct ModeratorControls: Decodable {
        public let kickUsers: Bool
        public let banUsers: Bool
        public let promoteDemoteMembers: Bool
    }

    public struct PrivateMessagingWithinGroups: Decodable {
        public let sendPrivateMessageToGroupMembers: Bool
    }
}

// MARK: - Call Features

public struct CallFeatures: Decodable {
    public let voiceAndVideoCalling: VoiceAndVideoCalling

    public struct VoiceAndVideoCalling: Decodable {
        public let oneOnOneVoiceCalling: Bool
        public let oneOnOneVideoCalling: Bool
        public let groupVideoConference: Bool
        public let groupVoiceConference: Bool
    }
}

// MARK: - Layout

public struct Layout: Decodable {
    public let withSideBar: Bool
    public let tabs: [String]
    public let chatType: String
}

// MARK: - NoCode

public struct NoCode: Decodable {
    public let docked: Bool
    public let styles: Styles

    public struct Styles: Decodable {
        public let buttonBackGround: String
        public let buttonShape: String
        public let openIcon: String
        public let closeIcon: String
        public let customJs: String
        public let customCss: String
    }
}

