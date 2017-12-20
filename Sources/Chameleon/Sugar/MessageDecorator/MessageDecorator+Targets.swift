
public extension MessageDecorator {
    func targetId() throws -> String {
        let targetId: String? = try
            message.thread.flatMap { try $0.targetId() }
            ?? message.im?.id
            ?? message.channel?.id
            ?? message.group?.id

        guard let value = targetId
            else { throw Error.unableToFind(value: #function) }

        return value
    }

    func target() throws -> TargetRepresentable {
        let target: TargetRepresentable? = try
            message.thread
            ?? message.channel.flatMap { try $0.value() }
            ?? message.im.flatMap { try $0.value() }
            ?? message.group.flatMap { try $0.value() }

        guard let value = target
            else { throw Error.unableToFind(value: #function) }

        return value
    }

    func threadTarget() throws -> TargetRepresentable {
        if let thread = message.thread {
            return thread
        }

        return TargetWrapper(
            name: "Thread",
            targetId: try targetId(),
            threadTs: message.ts
        )
    }
}

private struct TargetWrapper: TargetRepresentable {
    private let _targetId: String

    let name: String

    func targetId() throws -> String {
        return _targetId
    }
    let targetThread_ts: String?

    init(name: String, targetId: String, threadTs: String) {
        self.name = name
        self._targetId = targetId
        self.targetThread_ts = threadTs
    }
}
