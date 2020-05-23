import Foundation

public struct Image: Codable, Equatable {
    public static let type = "image"

    public var type: String
    public var image_url: URL
    public var alt_text: String
}
