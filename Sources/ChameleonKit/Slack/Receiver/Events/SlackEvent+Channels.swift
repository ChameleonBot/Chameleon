import Foundation

extension SlackEvent {
    public struct ChannelArchive: Codable, Equatable {
        public var channel: Identifier<Channel>
        public var user: Identifier<User>
    }

    public static var channelArchive: SlackEvent<ChannelArchive> {
        return .init(identifier: "channel_archive", type: "channel_archive")
    }
    public static var channelUnarchive: SlackEvent<ChannelArchive> {
        return .init(identifier: "channel_unarchive", type: "channel_unarchive")
    }
}

extension SlackEvent {
    public struct ChannelJoin: Codable, Equatable {
        public var channel: Identifier<Channel>
        public var user: Identifier<User>
        public var team: Identifier<Team>

        //    TODO
        //    The `channel_type` value is a single letter indicating the type of channel used in channel:
        //
        //    C - typically a public channel
        //    G - private channels (or groups) return this channel_type

        public var inviter: Identifier<User>?
    }

    public static var channelJoin: SlackEvent<ChannelJoin> {
        return .init(identifier: "member_joined_channel", type: "member_joined_channel")
    }
}

extension SlackEvent {
    public struct ChannelLeave: Codable, Equatable {
        public var channel: Identifier<Channel>
        public var user: Identifier<User>
        public var team: Identifier<Team>

        //    TODO
        //    The `channel_type` value is a single letter indicating the type of channel used in channel:
        //
        //    C - typically a public channel
        //    G - private channels (or groups) return this channel_type
    }

    public static var channelLeave: SlackEvent<ChannelLeave> {
        // TODO: there is also this event.., channel_left
        //{"token":"3DH2vLNNAK7Am2mWXV74vWZ1","team_id":"T02TB69LA","api_app_id":"A011RSVH7MH","event":{"type":"channel_left","channel":"C0165ENK8JU","actor_id":"U04UAVAEB","event_ts":"1592263107.000600"},"type":"event_callback","event_id":"Ev015EB73GG5","event_time":1592263107,"authed_users":["U011YPL825S"]}

        return .init(identifier: "member_left_channel", type: "member_left_channel")
    }
}

extension SlackEvent {
    public struct ChannelCreated: Codable, Equatable {
        public var id: Identifier<Channel>
        public var name: String
        @Convertible<Timestamp> public var created: Date
        public var creator: Identifier<User>
    }

    public static var channelCreated: SlackEvent<ChannelCreated> {
        return .init(identifier: "channel_created", type: "channel_created")
    }
}

extension SlackEvent {
    public struct ChannelDeleted: Codable, Equatable {
        private enum CodingKeys: String, CodingKey {
            case channel, user = "actor_id"
        }

        public var channel: Identifier<Channel>
        public var user: Identifier<User>
    }

    public static var channelDeleted: SlackEvent<ChannelDeleted> {
        return .init(identifier: "channel_deleted", type: "channel_deleted")
    }
}

extension SlackEvent {
    public struct ChannelRename: Codable, Equatable {
        public var id: Identifier<Channel>
        public var name: String
        @Convertible<Timestamp> public var created: Date
    }

    public static var channelRename: SlackEvent<ChannelRename> {
        return .init(identifier: "channel_rename", type: "channel_rename")
    }
}
