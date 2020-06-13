public protocol Action {
    var action_id: String { get }
}

public enum Actions: EquatableCodableElementSet {
    public static var decoders: [DecodingRoutine<Action>] {
        return [
            .item(Interaction.Button.init, when: "type", equals: Interaction.Button.type)
        ]
    }

    public static var encoders: [EncodingRoutine<Action>] {
        return [
            .item(Interaction.Button.self)
        ]
    }

    public static func isEqual(_ lhs: Action, _ rhs: Action) -> Bool {
        switch (lhs, rhs) {
        case (let lhs as Interaction.Button, let rhs as Interaction.Button): return lhs == rhs
        default: return false
        }
    }
}
