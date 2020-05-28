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
                case .formData: mediaType = .formData
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
