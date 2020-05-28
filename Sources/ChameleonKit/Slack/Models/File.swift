import Foundation

public struct File: Codable, Equatable {
    public var id: Identifier<File>

    @Convertible<StringTimestamp> public var created: Date
    @Convertible<StringTimestamp?> public var updated: Date?

    public var name: String
    public var title: String
    public var url: URL?
    public var size: Int
    public var comments_count: Int
    public var is_starred: Bool

    public var user: Identifier<User>
    public var channels: [Identifier<Channel>]
    public var groups: [Identifier<Channel>] // Identifier<Channel> \_____ can we consolidate all these into 'Channel' ?
    public var ims: [Identifier<Channel>] // Identifier<IM>         /

    public var mimetype: String
    public var filetype: FileType
    public var pretty_type: String

    public var mode: FileMode
    public var editable: Bool

    public var is_public: Bool
    public var public_url_shared: Bool

    public var is_external: Bool
    public var external_type: String

    public var url_private: URL
    public var url_private_download: URL
    public var permalink: URL
    public var permalink_public: URL
    public var edit_link: URL

    // MARK: - Image Properties
    public var thumb_64: URL?
    public var thumb_80: URL?
    public var thumb_360: URL?
    public var thumb_360_w: Int?
    public var thumb_360_h: Int?
    public var thumb_160: URL?
    public var thumb_360_gif: URL?
    public var image_exif_rotation: Int?
    public var original_w: Int?
    public var original_h: Int?
    public var deanimate_gif: URL?
    public var pjpeg: URL?
}

public struct FileMode: Codable, Equatable, RawRepresentable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension FileMode {
    public static var hosted: FileMode { .init(rawValue: #function) }
    public static var external: FileMode { .init(rawValue: #function) }
    public static var snippet: FileMode { .init(rawValue: #function) }
    public static var post: FileMode { .init(rawValue: #function) }
}

public struct FileType: RawRepresentable, Equatable, Codable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension FileType {
    public static var auto: FileType { .init(rawValue: #function) }
    public static var text: FileType { .init(rawValue: #function) }
    public static var javascript: FileType { .init(rawValue: #function) }
    public static var swift: FileType { .init(rawValue: #function) }
}
