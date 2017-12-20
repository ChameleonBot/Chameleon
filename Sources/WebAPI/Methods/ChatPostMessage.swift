
public struct ChatPostMessage: WebAPIRequest {
    public let message: ChatMessage
    public let endpoint = "chat.postMessage"
    public var body: [String: Any?] {
        return message.encode()
    }

    public init(message: ChatMessage) {
        self.message = message
    }

    public func handle(response: NetworkResponse) throws -> Void {
        //
    }
}
