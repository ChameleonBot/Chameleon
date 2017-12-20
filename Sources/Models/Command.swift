import Foundation

/// Represents the available Slack commands
public enum Command: RawRepresentable {
    /// Mention @channel
    case channel

    /// Mention @group
    case group

    /// Mention @here
    case here

    /// Mention @everyone
    case everyone

    /// Mention a specific user group
    case userGroup(id: String, name: String)

    /// Custom mention
    case custom(name: String)

    public init?(rawValue: String) {
        let basicRawValues = [Command.channel, Command.group, Command.here, Command.everyone]
        let subteamPrefix = "!subteam^"

        if let index = basicRawValues.index(where: { $0.rawValue == rawValue }) {
            self = basicRawValues[index]

        } else if rawValue.hasPrefix(subteamPrefix) {
            let components = rawValue[subteamPrefix.endIndex..<rawValue.endIndex].components(separatedBy: "|")
            guard
                components.count == 2,
                let id = components.first,
                let name = components.last
                else { return nil }

            self = .userGroup(id: id, name: name)

        } else {
            self = .custom(name: rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .channel: return "!channel"
        case .group: return "!group"
        case .here: return "!here"
        case .everyone: return "!everyone"
        case .userGroup(let id, let name): return "!subteam^\(id)|\(name)"
        case .custom(let name): return "!\(name)"
        }
    }
}
