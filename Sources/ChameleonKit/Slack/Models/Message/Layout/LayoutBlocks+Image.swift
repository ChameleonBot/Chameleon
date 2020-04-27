import Foundation

extension Message.Layout {
    public struct Image: Codable, Equatable {
        public static let type = "image"

        public var type: String
        public var image_url: URL
        public var alt_text: String
        public var title: Text.PlainText?
        public var block_id: String?
    }
}
