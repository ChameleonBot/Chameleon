
/// Represents an type that can produce a `ModelWebAPIRequest`
/// that converts an id into a full instance of this type
public protocol ModelWebAPIRequestRepresentable {
    /// Returns a `ModelWebAPIRequest` that attempts to convert the provided id into a complete model of `Self`
    static func request(id: String) -> ModelWebAPIRequest<Self>
}

extension Channel: ModelWebAPIRequestRepresentable {
    public static func request(id: String) -> ModelWebAPIRequest<Channel> {
        return ModelWebAPIRequest(request: ChannelsInfo(id: id))
    }
}

extension User: ModelWebAPIRequestRepresentable {
    public static func request(id: String) -> ModelWebAPIRequest<User> {
        if id[id.startIndex] == "B" { //bot_id
            return ModelWebAPIRequest(request: UserFromBotRequest(bot_id: id))
        } else {
            return ModelWebAPIRequest(request: UsersInfo(id: id))
        }
    }
}

extension BotUser: ModelWebAPIRequestRepresentable {
    public static func request(id: String) -> ModelWebAPIRequest<BotUser> {
        if id[id.startIndex] == "B" { //bot_id
            return ModelWebAPIRequest(request: BotsInfo(id: id))
        } else {
            return ModelWebAPIRequest(request: BotFromUserRequest(id: id))
        }
    }
}

extension IM: ModelWebAPIRequestRepresentable {
    public static func request(id: String) -> ModelWebAPIRequest<IM> {
        return ModelWebAPIRequest(request: IMFromListRequest(id: id))
    }
}

extension Group: ModelWebAPIRequestRepresentable {
    public static func request(id: String) -> ModelWebAPIRequest<Group> {
        return ModelWebAPIRequest(request: GroupsInfo(id: id))
    }
}
