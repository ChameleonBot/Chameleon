import Foundation

//public protocol ConversationContext: Codable { }
//
//public struct Channel: ConversationContext { }

public struct Conversation: Codable, Equatable {
    public var id: Identifier<Conversation>
    public var name: String
    public var name_normalized: String
    public var previous_names: [String]

    @Convertible<Timestamp> var created: Date
    public var creator: Identifier<User>

    public var is_archived: Bool
    public var is_general: Bool
    public var is_shared: Bool
    public var is_org_shared: Bool
    public var is_member: Bool
    public var is_private: Bool

    public var members: [Identifier<User>]

    public var topic: Topic?
    public var purpose: Purpose?
}

public struct Topic: Codable, Equatable {
    public var value: String
    public var creator: Identifier<User>
    @Convertible<Timestamp> public var last_set: Date
}

public struct Purpose: Codable, Equatable {
    public var value: String
    public var creator: Identifier<User>
    @Convertible<Timestamp> public var last_set: Date
}
