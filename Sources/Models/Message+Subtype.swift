
public extension Message {
    enum Subtype: String {
        case bot_message

        case channel_archive
        case channel_join
        case channel_leave
        case channel_name
        case channel_purpose
        case channel_topic
        case channel_unarchive

        case file_comment
        case file_mention
        case file_share

        case group_archive
        case group_join
        case group_leave
        case group_name
        case group_purpose
        case group_topic
        case group_unarchive

        case me_message

        case message_changed
        case message_deleted
        case message_replied

        case pinned_item
        case unpinned_item

        @available(*, deprecated)
        case reply_broadcast
        case thread_broadcast
    }
}
