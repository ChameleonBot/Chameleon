
public struct pong: RTMAPIEvent {
    public static func handle(packet: [String : Any]) throws -> Pong {
        return try Pong(decoder: Decoder(data: packet))
    }
}
