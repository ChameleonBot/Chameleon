import Foundation

extension Message {
    public struct Attachment: Codable, Equatable {
        public struct Field: Codable, Equatable {
            @Default<Empty> public var title: String
            @Default<Empty> public var value: String
            @Default<False> public var short: Bool
        }

        @Default<Empty> public var fallback: String
        @Default<Empty> public var text: String
        @Default<Empty> public var title: String

        public var title_link: URL?
        public var original_url: URL?

        @Default<Empty> public var fields: [Field]
        @ManyOf<LayoutBlocks> public var blocks: [LayoutBlock]
    }
}
