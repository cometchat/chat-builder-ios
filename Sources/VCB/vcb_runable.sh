//
//  VCBCompileTimeRunable.swift
//  CometChatUIKitSwift
//
//  Created by Suryansh on 09/06/25.
//

#!/bin/bash

# Path to Swift file
SWIFT_FILE="${PROJECT_DIR}/master-app/VCB/VCBStatic.swift"
# Path to config JSON
CONFIG_FILE="${PROJECT_DIR}/master-app/vcb_config.json"

# ========== STYLE ==========
BRAND_COLOR=$(jq -r '.data.settings.style.color.brandColor' "$CONFIG_FILE")
PRIMARY_TEXT_LIGHT=$(jq -r '.data.settings.style.color.primaryTextLight' "$CONFIG_FILE")
PRIMARY_TEXT_DARK=$(jq -r '.data.settings.style.color.primaryTextDark' "$CONFIG_FILE")
SECONDARY_TEXT_LIGHT=$(jq -r '.data.settings.style.color.secondaryTextLight' "$CONFIG_FILE")
SECONDARY_TEXT_DARK=$(jq -r '.data.settings.style.color.secondaryTextDark' "$CONFIG_FILE")

FONT=$(jq -r '.data.settings.style.typography.font' "$CONFIG_FILE")
FONT_SIZE=$(jq -r '.data.settings.style.typography.size' "$CONFIG_FILE" | tr '[:upper:]' '[:lower:]')

THEME=$(jq -r '.data.settings.style.theme' "$CONFIG_FILE")

# ========== CORE MESSAGING EXPERIENCE ==========
TYPING_INDICATOR=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.typingIndicator' "$CONFIG_FILE")
THREAD_CONV_AND_REPLIES=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.threadConversationAndReplies' "$CONFIG_FILE")
PHOTOS_SHARING=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.photosSharing' "$CONFIG_FILE")
VIDEO_SHARING=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.videoSharing' "$CONFIG_FILE")
AUDIO_SHARING=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.audioSharing' "$CONFIG_FILE")
FILE_SHARING=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.fileSharing' "$CONFIG_FILE")
EDIT_MESSAGE=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.editMessage' "$CONFIG_FILE")
DELETE_MESSAGE=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.deleteMessage' "$CONFIG_FILE")
MESSAGE_DELIVERY=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.messageDeliveryAndReadReceipts' "$CONFIG_FILE")
USER_PRESENCE=$(jq -r '.data.settings.chatFeatures.coreMessagingExperience.userAndFriendsPresence' "$CONFIG_FILE")

# ========== DEEPER USER ENGAGEMENT ==========
MENTIONS=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.mentions' "$CONFIG_FILE")
REACTIONS=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.reactions' "$CONFIG_FILE")
MESSAGE_TRANSLATION=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.messageTranslation' "$CONFIG_FILE")
POLLS=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.polls' "$CONFIG_FILE")
WHITEBOARD=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.collaborativeWhiteboard' "$CONFIG_FILE")
DOCUMENT=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.collaborativeDocument' "$CONFIG_FILE")
VOICE_NOTES=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.voiceNotes' "$CONFIG_FILE")
EMOJIS=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.emojis' "$CONFIG_FILE")
STICKERS=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.stickers' "$CONFIG_FILE")
USER_INFO=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.userInfo' "$CONFIG_FILE")
GROUP_INFO=$(jq -r '.data.settings.chatFeatures.deeperUserEngagement.groupInfo' "$CONFIG_FILE")

# ========== AI COPILOT ==========
CONVERSATION_STARTER=$(jq -r '.data.settings.chatFeatures.aiUserCopilot.conversationStarter' "$CONFIG_FILE")
CONVERSATION_SUMMARY=$(jq -r '.data.settings.chatFeatures.aiUserCopilot.conversationSummary' "$CONFIG_FILE")
SMART_REPLY=$(jq -r '.data.settings.chatFeatures.aiUserCopilot.smartReply' "$CONFIG_FILE")

# ========== GROUP MANAGEMENT ==========
CREATE_GROUP=$(jq -r '.data.settings.chatFeatures.groupManagement.createGroup' "$CONFIG_FILE")
ADD_MEMBERS=$(jq -r '.data.settings.chatFeatures.groupManagement.addMembersToGroups' "$CONFIG_FILE")
JOIN_LEAVE_GROUP=$(jq -r '.data.settings.chatFeatures.groupManagement.joinLeaveGroup' "$CONFIG_FILE")
DELETE_GROUP=$(jq -r '.data.settings.chatFeatures.groupManagement.deleteGroup' "$CONFIG_FILE")
VIEW_MEMBERS=$(jq -r '.data.settings.chatFeatures.groupManagement.viewGroupMembers' "$CONFIG_FILE")

# ========== MODERATOR CONTROLS ==========
KICK_USERS=$(jq -r '.data.settings.chatFeatures.moderatorControls.kickUsers' "$CONFIG_FILE")
BAN_USERS=$(jq -r '.data.settings.chatFeatures.moderatorControls.banUsers' "$CONFIG_FILE")
PROMOTE_DEMOTE=$(jq -r '.data.settings.chatFeatures.moderatorControls.promoteDemoteMembers' "$CONFIG_FILE")

# ========== PRIVATE MESSAGING ==========
PRIVATE_MESSAGE=$(jq -r '.data.settings.chatFeatures.privateMessagingWithinGroups.sendPrivateMessageToGroupMembers' "$CONFIG_FILE")

# ========== CALL FEATURES ==========
ONE_ON_ONE_VOICE=$(jq -r '.data.settings.callFeatures.voiceAndVideoCalling.oneOnOneVoiceCalling' "$CONFIG_FILE")
ONE_ON_ONE_VIDEO=$(jq -r '.data.settings.callFeatures.voiceAndVideoCalling.oneOnOneVideoCalling' "$CONFIG_FILE")
GROUP_VIDEO_CONF=$(jq -r '.data.settings.callFeatures.voiceAndVideoCalling.groupVideoConference' "$CONFIG_FILE")
GROUP_VOICE_CONF=$(jq -r '.data.settings.callFeatures.voiceAndVideoCalling.groupVoiceConference' "$CONFIG_FILE")

# ========== LAYOUT ==========
WITH_SIDEBAR=$(jq -r '.data.settings.layout.withSideBar' "$CONFIG_FILE")
CHAT_TYPE=$(jq -r '.data.settings.layout.chatType' "$CONFIG_FILE")
TABS=$(jq -r '.data.settings.layout.tabs | join(",")' "$CONFIG_FILE")

# ========== UPDATE SWIFT FILE ==========

# --- STYLE ---
sed -i '' "s/static var brandColor = \".*\"/static var brandColor = \"$BRAND_COLOR\"/" "$SWIFT_FILE"
sed -i '' "s/static var primaryTextLight = \".*\"/static var primaryTextLight = \"$PRIMARY_TEXT_LIGHT\"/" "$SWIFT_FILE"
sed -i '' "s/static var primaryTextDark = \".*\"/static var primaryTextDark = \"$PRIMARY_TEXT_DARK\"/" "$SWIFT_FILE"
sed -i '' "s/static var secondaryTextLight = \".*\"/static var secondaryTextLight = \"$SECONDARY_TEXT_LIGHT\"/" "$SWIFT_FILE"
sed -i '' "s/static var secondaryTextDark = \".*\"/static var secondaryTextDark = \"$SECONDARY_TEXT_DARK\"/" "$SWIFT_FILE"
sed -i '' "s/static var font = \".*\"/static var font = \"$FONT\"/" "$SWIFT_FILE"
sed -i '' "s/static var fontSize = \".*\"/static var fontSize = \"$FONT_SIZE\"/" "$SWIFT_FILE"
sed -i '' "s/static var theme = \".*\"/static var theme = \"$THEME\"/" "$SWIFT_FILE"

# --- CORE MESSAGING ---
sed -i '' "s/static var typingIndicator = .*/static var typingIndicator = $TYPING_INDICATOR/" "$SWIFT_FILE"
sed -i '' "s/static var threadConversationAndReplies = .*/static var threadConversationAndReplies = $THREAD_CONV_AND_REPLIES/" "$SWIFT_FILE"
sed -i '' "s/static var photosSharing = .*/static var photosSharing = $PHOTOS_SHARING/" "$SWIFT_FILE"
sed -i '' "s/static var videoSharing = .*/static var videoSharing = $VIDEO_SHARING/" "$SWIFT_FILE"
sed -i '' "s/static var audioSharing = .*/static var audioSharing = $AUDIO_SHARING/" "$SWIFT_FILE"
sed -i '' "s/static var fileSharing = .*/static var fileSharing = $FILE_SHARING/" "$SWIFT_FILE"
sed -i '' "s/static var editMessage = .*/static var editMessage = $EDIT_MESSAGE/" "$SWIFT_FILE"
sed -i '' "s/static var deleteMessage = .*/static var deleteMessage = $DELETE_MESSAGE/" "$SWIFT_FILE"
sed -i '' "s/static var messageDeliveryAndReadReceipts = .*/static var messageDeliveryAndReadReceipts = $MESSAGE_DELIVERY/" "$SWIFT_FILE"
sed -i '' "s/static var userAndFriendsPresence = .*/static var userAndFriendsPresence = $USER_PRESENCE/" "$SWIFT_FILE"

# --- USER ENGAGEMENT ---
sed -i '' "s/static var mentions = .*/static var mentions = $MENTIONS/" "$SWIFT_FILE"
sed -i '' "s/static var reactions = .*/static var reactions = $REACTIONS/" "$SWIFT_FILE"
sed -i '' "s/static var messageTranslation = .*/static var messageTranslation = $MESSAGE_TRANSLATION/" "$SWIFT_FILE"
sed -i '' "s/static var polls = .*/static var polls = $POLLS/" "$SWIFT_FILE"
sed -i '' "s/static var collaborativeWhiteboard = .*/static var collaborativeWhiteboard = $WHITEBOARD/" "$SWIFT_FILE"
sed -i '' "s/static var collaborativeDocument = .*/static var collaborativeDocument = $DOCUMENT/" "$SWIFT_FILE"
sed -i '' "s/static var voiceNotes = .*/static var voiceNotes = $VOICE_NOTES/" "$SWIFT_FILE"
sed -i '' "s/static var emojis = .*/static var emojis = $EMOJIS/" "$SWIFT_FILE"
sed -i '' "s/static var stickers = .*/static var stickers = $STICKERS/" "$SWIFT_FILE"
sed -i '' "s/static var userInfo = .*/static var userInfo = $USER_INFO/" "$SWIFT_FILE"
sed -i '' "s/static var groupInfo = .*/static var groupInfo = $GROUP_INFO/" "$SWIFT_FILE"

# --- AI FEATURES ---
sed -i '' "s/static var conversationStarter = .*/static var conversationStarter = $CONVERSATION_STARTER/" "$SWIFT_FILE"
sed -i '' "s/static var conversationSummary = .*/static var conversationSummary = $CONVERSATION_SUMMARY/" "$SWIFT_FILE"
sed -i '' "s/static var smartReply = .*/static var smartReply = $SMART_REPLY/" "$SWIFT_FILE"

# --- GROUP MANAGEMENT ---
sed -i '' "s/static var createGroup = .*/static var createGroup = $CREATE_GROUP/" "$SWIFT_FILE"
sed -i '' "s/static var addMembersToGroups = .*/static var addMembersToGroups = $ADD_MEMBERS/" "$SWIFT_FILE"
sed -i '' "s/static var joinLeaveGroup = .*/static var joinLeaveGroup = $JOIN_LEAVE_GROUP/" "$SWIFT_FILE"
sed -i '' "s/static var deleteGroup = .*/static var deleteGroup = $DELETE_GROUP/" "$SWIFT_FILE"
sed -i '' "s/static var viewGroupMembers = .*/static var viewGroupMembers = $VIEW_MEMBERS/" "$SWIFT_FILE"

# --- MODERATOR CONTROLS ---
sed -i '' "s/static var kickUsers = .*/static var kickUsers = $KICK_USERS/" "$SWIFT_FILE"
sed -i '' "s/static var banUsers = .*/static var banUsers = $BAN_USERS/" "$SWIFT_FILE"
sed -i '' "s/static var promoteDemoteMembers = .*/static var promoteDemoteMembers = $PROMOTE_DEMOTE/" "$SWIFT_FILE"

# --- PRIVATE MESSAGING ---
sed -i '' "s/static var sendPrivateMessageToGroupMembers = .*/static var sendPrivateMessageToGroupMembers = $PRIVATE_MESSAGE/" "$SWIFT_FILE"

# --- CALL FEATURES ---
sed -i '' "s/static var oneOnOneVoiceCalling = .*/static var oneOnOneVoiceCalling = $ONE_ON_ONE_VOICE/" "$SWIFT_FILE"
sed -i '' "s/static var oneOnOneVideoCalling = .*/static var oneOnOneVideoCalling = $ONE_ON_ONE_VIDEO/" "$SWIFT_FILE"
sed -i '' "s/static var groupVideoConference = .*/static var groupVideoConference = $GROUP_VIDEO_CONF/" "$SWIFT_FILE"
sed -i '' "s/static var groupVoiceConference = .*/static var groupVoiceConference = $GROUP_VOICE_CONF/" "$SWIFT_FILE"

# --- LAYOUT ---
sed -i '' "s/static var withSideBar = .*/static var withSideBar = $WITH_SIDEBAR/" "$SWIFT_FILE"
sed -i '' "s/static var chatType = \".*\"/static var chatType = \"$CHAT_TYPE\"/" "$SWIFT_FILE"
# You may want to convert TABS string to Swift array manually, or handle carefully if updating dynamically

echo "✅ VCBStatic.swift updated successfully!"
