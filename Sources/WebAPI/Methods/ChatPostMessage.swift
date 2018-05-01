
public struct ChatPostMessage: WebAPIRequest {
    public var url: String {
        return message.response_url ?? WebAPIURL(base: DefaultBaseURL, endpoint)
    }
    public var encoding: Encoding {
        return message.response_url == nil ? .form : .json
    }
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
