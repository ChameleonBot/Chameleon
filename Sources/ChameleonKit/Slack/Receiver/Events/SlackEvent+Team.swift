extension SlackEvent {
    public static var teamJoin: SlackEvent<User> {
        return .init(identifier: "team_join", type: "team_join")
    }
}
