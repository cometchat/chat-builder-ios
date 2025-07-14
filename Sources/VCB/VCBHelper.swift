//
//  VCB API Call.swift
//  CometChatUIKitSwift
//
//  Created by Suryansh on 09/06/25.
//

import Foundation
import UIKit

class VCBHelper {
    
    //MARK: - From local json
    
    
    //MARK: - API Call related function
    static func fetchStyle(code: String, completion: @escaping (Settings?) -> Void, apiFailure: @escaping (String) -> Void) {
        guard let url = URL(string: "https://apivcb.cometchat-staging.com/v1/builders/\(code)") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // or "POST" if needed
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error:", error?.localizedDescription ?? "Unknown error")
                apiFailure(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                applyToVCBStatic(decodedResponse.data.settings)
                completion(decodedResponse.data.settings)
            } catch {
                print("Decoding error:", error)
                completion(nil)
            }
        }.resume()
    }
    
//    static func applyToVCBStatic(_ settings: Settings) {
//        
//        // MARK: - Style
//        VCBStatic.Style.theme = settings.style.theme
//        
//        VCBStatic.Style.Font.font = settings.style.typography.font
//        VCBStatic.Style.Font.fontSize = settings.style.typography.size
//        
//        VCBStatic.Style.Color.brandColor = settings.style.color.brandColor
//        VCBStatic.Style.Color.primaryTextLight = settings.style.color.primaryTextLight
//        VCBStatic.Style.Color.primaryTextDark = settings.style.color.primaryTextDark
//        VCBStatic.Style.Color.secondaryTextLight = settings.style.color.secondaryTextLight
//        VCBStatic.Style.Color.secondaryTextDark = settings.style.color.secondaryTextDark
//
//        // MARK: - Chat Features - Core Messaging
//        let core = settings.chatFeatures.coreMessagingExperience
//        VCBStatic.ChatFeatures.CoreMessagingExperience.typingIndicator = core.typingIndicator
//        VCBStatic.ChatFeatures.CoreMessagingExperience.threadConversationAndReplies = core.threadConversationAndReplies
//        VCBStatic.ChatFeatures.CoreMessagingExperience.photosSharing = core.photosSharing
//        VCBStatic.ChatFeatures.CoreMessagingExperience.videosSharing = core.videoSharing
//        VCBStatic.ChatFeatures.CoreMessagingExperience.audioSharing = core.audioSharing
//        VCBStatic.ChatFeatures.CoreMessagingExperience.fileSharing = core.fileSharing
//        VCBStatic.ChatFeatures.CoreMessagingExperience.editMessage = core.editMessage
//        VCBStatic.ChatFeatures.CoreMessagingExperience.deleteMessage = core.deleteMessage
//        VCBStatic.ChatFeatures.CoreMessagingExperience.messageDeliveryAndReadReceipts = core.messageDeliveryAndReadReceipts
//        VCBStatic.ChatFeatures.CoreMessagingExperience.userAndFriendsPresence = core.userAndFriendsPresence
//
//        // MARK: - Chat Features - Deeper User Engagement
//        let engage = settings.chatFeatures.deeperUserEngagement
//        VCBStatic.ChatFeatures.DeeperUserEngagement.mentions = engage.mentions
//        VCBStatic.ChatFeatures.DeeperUserEngagement.reactions = engage.reactions
//        VCBStatic.ChatFeatures.DeeperUserEngagement.messageTranslation = engage.messageTranslation
//        VCBStatic.ChatFeatures.DeeperUserEngagement.polls = engage.polls
//        VCBStatic.ChatFeatures.DeeperUserEngagement.collaborativeWhiteboard = engage.collaborativeWhiteboard
//        VCBStatic.ChatFeatures.DeeperUserEngagement.collaborativeDocument = engage.collaborativeDocument
//        VCBStatic.ChatFeatures.DeeperUserEngagement.voiceNotes = engage.voiceNotes
//        VCBStatic.ChatFeatures.DeeperUserEngagement.emojis = engage.emojis
//        VCBStatic.ChatFeatures.DeeperUserEngagement.stickers = engage.stickers
//        VCBStatic.ChatFeatures.DeeperUserEngagement.userInfo = engage.userInfo
//        VCBStatic.ChatFeatures.DeeperUserEngagement.groupInfo = engage.groupInfo
//
//        // MARK: - Chat Features - AI Copilot
//        let ai = settings.chatFeatures.aiUserCopilot
//        VCBStatic.ChatFeatures.AiUserCopilot.conversationStarter = ai.conversationStarter
//        VCBStatic.ChatFeatures.AiUserCopilot.conversationSummary = ai.conversationSummary
//        VCBStatic.ChatFeatures.AiUserCopilot.smartReply = ai.smartReply
//
//        // MARK: - Chat Features - Group Management
//        let groupMgmt = settings.chatFeatures.groupManagement
//        VCBStatic.ChatFeatures.GroupManagement.createGroup = groupMgmt.createGroup
//        VCBStatic.ChatFeatures.GroupManagement.addMembersToGroups = groupMgmt.addMembersToGroups
//        VCBStatic.ChatFeatures.GroupManagement.joinLeaveGroup = groupMgmt.joinLeaveGroup
//        VCBStatic.ChatFeatures.GroupManagement.deleteGroup = groupMgmt.deleteGroup
//        VCBStatic.ChatFeatures.GroupManagement.viewGroupMembers = groupMgmt.viewGroupMembers
//
//        // MARK: - Chat Features - Moderator Controls
//        let mod = settings.chatFeatures.moderatorControls
//        VCBStatic.ChatFeatures.ModeratorControls.kickUsers = mod.kickUsers
//        VCBStatic.ChatFeatures.ModeratorControls.banUsers = mod.banUsers
//        VCBStatic.ChatFeatures.ModeratorControls.promoteDemoteMembers = mod.promoteDemoteMembers
//
//        // MARK: - Chat Features - Private Messaging
//        VCBStatic.ChatFeatures.PrivateMessagingWithinGroups.sendPrivateMessageToGroupMembers =
//            settings.chatFeatures.privateMessagingWithinGroups.sendPrivateMessageToGroupMembers
//
//        // MARK: - Call Features
//        let call = settings.callFeatures.voiceAndVideoCalling
//        VCBStatic.CallFeatures.VoiceAndVideoCalling.oneOnOneVoiceCalling = call.oneOnOneVoiceCalling
//        VCBStatic.CallFeatures.VoiceAndVideoCalling.oneOnOneVideoCalling = call.oneOnOneVideoCalling
//        VCBStatic.CallFeatures.VoiceAndVideoCalling.groupVideoConference = call.groupVideoConference
//        VCBStatic.CallFeatures.VoiceAndVideoCalling.groupVoiceConference = call.groupVoiceConference
//
//        // MARK: - Layout
//        VCBStatic.Layout.withSideBar = settings.layout.withSideBar
//        VCBStatic.Layout.chatType = settings.layout.chatType
//        VCBStatic.Layout.tabs = settings.layout.tabs
//
//        // MARK: - No Code UI
//        let nocode = settings.noCode
//        VCBStatic.NoCode.docked = nocode.docked
//        VCBStatic.NoCode.Styles.buttonBackground = nocode.styles.buttonBackGround
//        VCBStatic.NoCode.Styles.buttonShape = nocode.styles.buttonShape
//        VCBStatic.NoCode.Styles.openIcon = nocode.styles.openIcon
//        VCBStatic.NoCode.Styles.closeIcon = nocode.styles.closeIcon
//        VCBStatic.NoCode.Styles.customJS = nocode.styles.customJs
//        VCBStatic.NoCode.Styles.customCSS = nocode.styles.customCss
//    }
    
    static func applyToVCBStatic(_ settings: Settings) {

        var newConfig = VCBStaticConfig.defaultConfig()

        // MARK: - Style
        newConfig.style = .init(
            theme: settings.style.theme,
            color: .init(
                brandColor: settings.style.color.brandColor,
                primaryTextLight: settings.style.color.primaryTextLight,
                primaryTextDark: settings.style.color.primaryTextDark,
                secondaryTextLight: settings.style.color.secondaryTextLight,
                secondaryTextDark: settings.style.color.secondaryTextDark
            ),
            typography: .init(
                font: settings.style.typography.font,
                size: settings.style.typography.size
            )
        )

        // MARK: - Core Messaging
        newConfig.chatFeatures.coreMessagingExperience = .init(
            typingIndicator: settings.chatFeatures.coreMessagingExperience.typingIndicator,
            threadConversationAndReplies: settings.chatFeatures.coreMessagingExperience.threadConversationAndReplies,
            photosSharing: settings.chatFeatures.coreMessagingExperience.photosSharing,
            videoSharing: settings.chatFeatures.coreMessagingExperience.videoSharing,
            audioSharing: settings.chatFeatures.coreMessagingExperience.audioSharing,
            fileSharing: settings.chatFeatures.coreMessagingExperience.fileSharing,
            editMessage: settings.chatFeatures.coreMessagingExperience.editMessage,
            deleteMessage: settings.chatFeatures.coreMessagingExperience.deleteMessage,
            messageDeliveryAndReadReceipts: settings.chatFeatures.coreMessagingExperience.messageDeliveryAndReadReceipts,
            userAndFriendsPresence: settings.chatFeatures.coreMessagingExperience.userAndFriendsPresence
        )

        // MARK: - Deeper Engagement
        newConfig.chatFeatures.deeperUserEngagement = .init(
            mentions: settings.chatFeatures.deeperUserEngagement.mentions,
            reactions: settings.chatFeatures.deeperUserEngagement.reactions,
            messageTranslation: settings.chatFeatures.deeperUserEngagement.messageTranslation,
            polls: settings.chatFeatures.deeperUserEngagement.polls,
            collaborativeWhiteboard: settings.chatFeatures.deeperUserEngagement.collaborativeWhiteboard,
            collaborativeDocument: settings.chatFeatures.deeperUserEngagement.collaborativeDocument,
            voiceNotes: settings.chatFeatures.deeperUserEngagement.voiceNotes,
            emojis: settings.chatFeatures.deeperUserEngagement.emojis,
            stickers: settings.chatFeatures.deeperUserEngagement.stickers,
            userInfo: settings.chatFeatures.deeperUserEngagement.userInfo,
            groupInfo: settings.chatFeatures.deeperUserEngagement.groupInfo
        )

        // MARK: - AI Copilot
        newConfig.chatFeatures.aiUserCopilot = .init(
            conversationStarter: settings.chatFeatures.aiUserCopilot.conversationStarter,
            conversationSummary: settings.chatFeatures.aiUserCopilot.conversationSummary,
            smartReply: settings.chatFeatures.aiUserCopilot.smartReply
        )

        // MARK: - Group Management
        newConfig.chatFeatures.groupManagement = .init(
            createGroup: settings.chatFeatures.groupManagement.createGroup,
            addMembersToGroups: settings.chatFeatures.groupManagement.addMembersToGroups,
            joinLeaveGroup: settings.chatFeatures.groupManagement.joinLeaveGroup,
            deleteGroup: settings.chatFeatures.groupManagement.deleteGroup,
            viewGroupMembers: settings.chatFeatures.groupManagement.viewGroupMembers
        )

        // MARK: - Moderator Controls
        newConfig.chatFeatures.moderatorControls = .init(
            kickUsers: settings.chatFeatures.moderatorControls.kickUsers,
            banUsers: settings.chatFeatures.moderatorControls.banUsers,
            promoteDemoteMembers: settings.chatFeatures.moderatorControls.promoteDemoteMembers
        )

        // MARK: - Private Messaging
        newConfig.chatFeatures.privateMessagingWithinGroups = .init(
            sendPrivateMessageToGroupMembers: settings.chatFeatures.privateMessagingWithinGroups.sendPrivateMessageToGroupMembers
        )

        // MARK: - Call Features
        newConfig.callFeatures = .init(
            voiceAndVideoCalling: .init(
                oneOnOneVoiceCalling: settings.callFeatures.voiceAndVideoCalling.oneOnOneVoiceCalling,
                oneOnOneVideoCalling: settings.callFeatures.voiceAndVideoCalling.oneOnOneVideoCalling,
                groupVideoConference: settings.callFeatures.voiceAndVideoCalling.groupVideoConference,
                groupVoiceConference: settings.callFeatures.voiceAndVideoCalling.groupVoiceConference
            )
        )

        // MARK: - Layout
        newConfig.layout = .init(
            withSideBar: settings.layout.withSideBar,
            tabs: settings.layout.tabs,
            chatType: settings.layout.chatType
        )

        // MARK: - NoCode UI (optional, not in your new struct, consider adding if needed)
        // If needed, extend VCBStaticConfig with a `noCode` property and map similarly.

        // 🔄 If you want this newConfig to be used by your app:
        // Replace `VCBStatic.shared` with this new config (only if shared is a `var`)

        // VCBStatic.shared = newConfig ❌ <- Not possible if shared is a let constant

        // Instead, refactor your `VCBStatic` to accept this config (inject it or store it)
    }
    
    static func initiateVCBWith(code: String, completion: @escaping (Settings) -> Void, failure: @escaping () -> Void, apiFailure: @escaping (String) -> Void) {
        VCBHelper.fetchStyle(code: code) { setting in
            DispatchQueue.main.async(execute: {
                if let setting = setting {
                    completion(setting)
                }else{
                    failure()
                }
            })
        } apiFailure: { error in
            apiFailure(error)
        }
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
