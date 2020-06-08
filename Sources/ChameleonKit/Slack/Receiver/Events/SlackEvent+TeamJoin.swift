extension SlackEvent {
    public static var teamJoin: SlackEvent<User> {
        return .init(identifier: "team_join", canHandle: { type, json in type == "team_join" })
    }
}
