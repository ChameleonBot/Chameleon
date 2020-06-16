import Foundation

public struct EmojiAdded: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case emoji = "name"
        case value
    }

    public var emoji: Emoji
    public var value: URL
}

extension SlackEvent {
    public static var emojiAdd: SlackEvent<EmojiAdded> {
        return .init(
            identifier: "emoji_add",
            canHandle: { type, json in
                return type == "emoji_changed" && (json["subtype"] as? String) == "add"
            }
        )
    }
}

public struct EmojiRemoved: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case emoji = "names"
    }

    public var emoji: [Emoji]
}

extension SlackEvent {
    public static var emojiRemove: SlackEvent<EmojiRemoved> {
        return .init(
            identifier: "emoji_remove",
            canHandle: { type, json in
                return type == "emoji_changed" && (json["subtype"] as? String) == "remove"
            }
        )
    }
}
