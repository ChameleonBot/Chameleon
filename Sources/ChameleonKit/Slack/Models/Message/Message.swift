import Foundation

public struct Message: Codable, Equatable {
    public var team: Identifier<Team>
    public var channel: Identifier<Channel>
    public var channel_type: Channel.Kind
    public var user: Identifier<User>
    public var text: String

    @Convertible<StringTimestamp?> public var ts: Date?
    @Convertible<StringTimestamp?> public var event_ts: Date?
    @Convertible<StringTimestamp?> public var thread_ts: Date?

    public var subtype: Subtype?
    public var edited: Edit?
    @Indirect public var previous: Message?

    @Default<False> public var hidden: Bool
    @Default<False> public var is_starred: Bool
    @Default<Empty> public var pinned_to: [Identifier<Channel>]

    @ManyOf<LayoutBlocks> public var blocks: [LayoutBlock]
}

extension Message {
    public enum Thread {
        case unthreaded
        case parent
        case reply
    }
    public var threading: Thread {
        guard let thread_ts = $thread_ts else { return .unthreaded }

        if thread_ts == $ts { return .parent }
        else { return .reply }
    }
}

extension Message {
    public struct Edit: Codable, Equatable {
        public var user: Identifier<User>
        @Convertible<StringTimestamp> public var ts: Date
    }
}

// this is a very basic message, most notable is `blocks` doesn't exist.. need to either 1) make it optional or 2) embed nil handling into the ManyOf/PR (until stacking is supported)
//
//"type": "message",
//"text": "You have been removed from #help by <@U04UAVAEB>",
//"user": "USLACKBOT",
//"ts": "1587516010.000100",
//"team": "T02TB69LA",
//"channel": "D011YPL83QC",
//"event_ts": "1587516010.000100",
//"channel_type": "im"
