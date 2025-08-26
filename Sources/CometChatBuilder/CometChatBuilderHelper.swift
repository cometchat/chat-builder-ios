
import Foundation
import UIKit

class CometChatBuilderHelper {
    
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
                applyBuilderSettings(decodedResponse.data.settings)
                completion(decodedResponse.data.settings)
            } catch {
                print("Decoding error:", error)
                completion(nil)
            }
        }.resume()
    }
    
    static func applyBuilderSettings(_ settings: Settings) {

        var newConfig = BuilderStaticConfig.defaultConfig()

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
        
        CometChatBuilderSettings.applyFromAPI(newConfig)

    }
    
    static func initiateBuilderWith(code: String, completion: @escaping (Settings) -> Void, failure: @escaping () -> Void, apiFailure: @escaping (String) -> Void) {
        CometChatBuilderHelper.fetchStyle(code: code) { setting in
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
