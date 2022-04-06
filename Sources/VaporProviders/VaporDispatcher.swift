import ChameleonKit
import Vapor

public class VaporDispatcher: SlackDispatcher {
    private let application: Application
    private let client: Client
    private let token: String

    public init(application: Application, token: String) throws {
        self.application = application
		self.client = application.client
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

                let mediaType: HTTPMediaType
                switch action.encoding {
                case .url:  mediaType = .urlEncodedForm
                case .json: mediaType = .json
                case .formData: mediaType = .formData
                }

                try request.content.encode(AnyEncodable(packet), as: mediaType)

				print(request)
            }
            .flatMapThrowing { response in
                let data = response.body ?? .init()
                let json = try JSONSerialization.jsonObject(with: data, options: [])

                guard let packet = json as? [String: Any] else { throw SlackPacketError.invalidPacket(json) }

                return try action.handle(packet)
            }
            .wait()
    }
}
