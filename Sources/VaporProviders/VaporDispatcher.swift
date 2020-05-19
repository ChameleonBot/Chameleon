import ChameleonKit
import Vapor
import HTTP
import URLEncodedForm

public class VaporDispatcher: SlackDispatcher {
    private let application: Application
    private let client: Client
    private let token: String

    public init(application: Application, token: String) throws {
        self.application = application
        self.client = try application.make(Client.self)
        self.token = token
    }

    public func perform<T>(_ action: SlackAction<T>) throws -> T {
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "Bearer \(token)")

        let method: HTTPMethod
        switch action.method {
        case .get: method = .GET
        case .post: method = .POST
        }

        return try client
            .send(method, headers: headers, to: "https://slack.com/api/\(action.name)") { request in
                guard let packet = action.packet else { return }

                let mediaType: MediaType
                switch action.encoding {
                case .url:  mediaType = .urlEncodedForm
                case .json: mediaType = .json
                }

                try request.content.encode(AnyEncodable(packet), as: mediaType)

                print(request.debugDescription)
            }
            .map { response in
                let data = response.http.body.data ?? .init()
                guard
                    let packet = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    else { throw SlackPacketError.invalidPacket }

                return try action.handle(packet)
            }
            .wait()
    }
}

/**

 channel
 text

 blocks

 thread_ts
 reply_broadcast

 unfurl_links
 unfurl_media

 link_names (default true)
 mrkdwn  (default true)
 parse : none/full (default none)

 */

//public struct ChatMessage {
//    public let response_url: String?
//
//    public let channel: String?
//    public let text: String
//
//    public let parse: Parse?
//    public let link_names: Bool?
//    public let unfurl_links: Bool?
//
//    public let unfurl_media: Bool?
//
//    public let username: String?
//    public let as_user: Bool?
//
//    public let icon_url: String?
//    public let icon_emoji: String?
//
//    public let thread_ts: String?
//    public let reply_broadcast: Bool?
//
//    public let attachments: [Attachment]



//var headers: HTTPHeaders = .init()
//let body = HTTPBody(string: a)
//let httpReq = HTTPRequest(
//    method: .POST,
//    url: URL(string: "/post")!,
//    headers: headers,
//    body: body)
//
//let client = HTTPClient.connect(hostname: "httpbin.org", on: req)
//
//let httpRes = client.flatMap(to: HTTPResponse.self) { client in
//    return client.send(httpReq)
//}

//

//let data = httpRes.flatMap(to: ExampleData.self) { httpResponse in
//    let response = Response(http: httpResponse, using: req)
//    return try response.content.decode(ExampleData.self)
//}
