
private func isThread(decoder: Common.Decoder) -> Bool {
    guard
        let thread_ts: String = try? decoder.value(at: ["thread_ts"]),
        let ts: String = try? decoder.value(at: ["ts"]),
        thread_ts != ts // true here would mean the message is the root
        else { return false }

    return true
}

func channelPointer(from decoder: Common.Decoder) -> ModelPointer<Channel>? {
    guard
        let pointerId: String = try? decoder.value(at: ["channel"]),
        pointerId.hasPrefix("C")
        else { return nil }

    return ModelPointer<Channel>(id: pointerId)
}
func imPointer(from decoder: Common.Decoder) -> ModelPointer<IM>? {
    guard
        !isThread(decoder: decoder),
        let pointerId: String = try? decoder.value(at: ["channel"]),
        pointerId.hasPrefix("D")
        else { return nil }

    return ModelPointer<IM>(id: pointerId)
}
func messageThread(from decoder: Common.Decoder) throws -> Thread? {
    guard isThread(decoder: decoder) else { return nil }

    return try Thread(decoder: decoder)
}
func groupPointer(from decoder: Common.Decoder) -> ModelPointer<Group>? {
    guard
        !isThread(decoder: decoder),
        let pointerId: String = try? decoder.value(at: ["channel"]),
        pointerId.hasPrefix("G")
        else { return nil }

    return ModelPointer<Group>(id: pointerId)
}
