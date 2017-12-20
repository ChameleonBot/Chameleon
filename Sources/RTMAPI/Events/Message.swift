
// Whats working?:
// - channels
// [x] new messages
// [x] message edits
// [x] new threads
// [x] thread edits
// - IMs
// [x] new messages
// [x] message edits
// [x] new threads
// [x] thread edits

// What needs doing?
// ...

public struct message: RTMAPIEvent {
    public static func handle(packet: [String : Any]) throws -> (message: Message, previous: Message?) {
        let messagePacket = packet + (packet["message"] as? [String: Any] ?? [:])
        var previousPacket = packet["previous_message"] as? [String: Any]

        // fill in holes left by api
        if previousPacket?["channel"] == nil {
            previousPacket?["channel"] = messagePacket["channel"]
        }

        return (
            message: try Message(decoder: Decoder(data: messagePacket)),
            previous: try previousPacket.map(Decoder.init).map(Message.init)
        )
    }
}
