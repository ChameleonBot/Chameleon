import Foundation

extension WebAPI {
    public enum Scope: String {
        case identify
        case client
        case admin
        case bot
        case channels_history = "channels:history"
        case channels_read = "channels:read"
        case channels_write = "channels:write"
        case chat_write_bot = "chat:write:bot"
        case chat_write_user = "chat:write:user"
        case dnd_read = "dnd:read"
        case dnd_write = "dnd:write"
        case emoji_read = "emoji:read"
        case files_read = "files:read"
        case files_write_user = "files:write:user"
        case groups_history = "groups:history"
        case groups_read = "groups:read"
        case groups_write = "groups:write"
        case identity_basic = "identity.basic"
        case im_history = "im:history"
        case im_read = "im:read"
        case im_write = "im:write"
        case mpim_history = "mpim:history"
        case mpim_read = "mpim:read"
        case mpim_write = "mpim:write"
        case pins_read = "pins:read"
        case pins_write = "pins:write"
        case reactions_read = "reactions:read"
        case reactions_write = "reactions:write"
        case reminders_read = "reminders:read"
        case reminders_write = "reminders:write"
        case search_read = "search:read"
        case stars_read = "stars:read"
        case stars_write = "stars:write"
        case team_read = "team:read"
        case usergroups_read = "usergroups:read"
        case usergroups_write = "usergroups:write"
        case users_profile_read = "users.profile:read"
        case users_profile_write = "users.profile:write"
        case users_read = "users:read"
        case users_write = "users:write"
    }
}
