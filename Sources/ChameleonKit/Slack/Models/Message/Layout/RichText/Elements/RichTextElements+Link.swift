import Foundation

extension Message.Layout.RichText.Element {
    public struct Link: Codable, Equatable {
        public static let type = "link"

        public var type: String
        public var text: String?
        public var url: URL
    }
}
