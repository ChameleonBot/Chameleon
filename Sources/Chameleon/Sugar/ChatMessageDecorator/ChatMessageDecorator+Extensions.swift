
public enum ResponseTarget {
    case inline
    case threaded
}

public extension MessageDecorator {
    func respond(_ targetType: ResponseTarget = .inline) throws -> ChatMessageDecorator {
        let responseTarget: TargetRepresentable

        switch targetType {
        case .inline:
            responseTarget = try target()
        case .threaded:
            responseTarget = try threadTarget()
        }

        return ChatMessageDecorator(target: responseTarget)
    }
}
