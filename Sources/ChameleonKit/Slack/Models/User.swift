import Foundation

public struct User: Codable, Equatable {
    public var id: Identifier<User>
    public var team_id: Identifier<Team>
    public var name: String
    public var real_name: String

    @Convertible<Timestamp> public var updated: Date

    public var color: Color

    public var tz: String
    public var tz_label: String
    public var tz_offset: TimeInterval

    public var deleted: Bool
    public var is_admin: Bool
    public var is_owner: Bool
    public var is_primary_owner: Bool
    public var is_bot: Bool
    public var is_app_user: Bool

    public var locale: String

    public var profile: Profile
}

public struct Profile: Codable, Equatable {
    public var title: String
    public var real_name: String?
    public var real_name_normalized: String?
    public var display_name: String
    public var display_name_normalized: String

    public var status_text: String
    public var status_emoji: Emoji
    @Convertible<Timestamp> public var status_expiration: Date

    public var first_name: String?
    public var last_name: String?
    public var email: String?
    
    public var image_original: URL?
    public var image_24: URL?
    public var image_32: URL?
    public var image_48: URL?
    public var image_72: URL?
    public var image_192: URL?
    public var image_512: URL?
}
