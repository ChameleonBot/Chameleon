import Foundation

public struct ChatPermalink: WebAPIRequest {
    public let channelID: String?
    public let ts: String
    
    public let endpoint = "chat.getPermalink"
    public var body: [String : Any?] {
        return ["channel": channelID, "message_ts": ts]
    }
    
    public init(message: Message) {
        self.channelID = message.channel?.id
        self.ts = message.ts
    }
    
    public func handle(response: NetworkResponse) throws -> String {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["permalink"] as? String
            else { throw NetworkError.invalidResponse(response) }
        return data
        
    }
}
