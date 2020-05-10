import Foundation

public struct Permalink: Codable, Equatable {
    public var channel: Identifier<Channel>
    public var permalink: URL
}
