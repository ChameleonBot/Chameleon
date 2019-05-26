import Chameleon
import Foundation

public struct ChatPermalink: WebAPIRequest {
    public let id: String
    public let ts: String
    
    public let endpoint = "chat.getPermalink"
    public var body: [String : Any?] {
        return ["channel": id, "ts": ts]
    }
    
    public init(id: String, ts: String) {
        self.id = id
        self.ts = ts
    }
    
    public func handle(response: NetworkResponse) throws -> URL {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["permalink"] as? String,
            let url = URL(string: data)
            else { throw NetworkError.invalidResponse(response) }
        
        return url
        
    }
}
