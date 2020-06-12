import ChameleonKit
import Vapor
import HTTP


//
private class Printer: Middleware {
    init() { }

    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        print(request)
        print("")
        return try next.respond(to: request)
    }
}
//

public class VaporReceiver: SlackReceiver {
    // MARK: - Private Properties
    private let application: Application
    private let router: Router
    private let verificationToken: String
    private let eventHandler: SlackEventHandler
    private let slashCommandHandler: SlashCommandHandler

    // MARK: - Public Properties
    public var onError: (Error) -> Void = { print("\nVaporReceiver Error:", $0) }

    // MARK: - Lifecycle
    public init(application: Application, verificationToken: String) throws {
        self.application = application
        self.router = try application.make(Router.self)
        self.verificationToken = verificationToken
        self.eventHandler = SlackEventHandler(verificationToken: verificationToken)
        self.slashCommandHandler = SlashCommandHandler(verificationToken: verificationToken)

        enableEvents()
        enableSlashCommands()
    }

    // MARK: - Public Functions
    @discardableResult
    public func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void) -> Cancellable {
        return eventHandler.listen(for: event, closure)
    }
    @discardableResult
    public func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlashCommand) throws -> Void) -> Cancellable {
        return slashCommandHandler.listen(for: slashCommand, closure)
    }

    public func start() throws {
        try application.run()
    }

    // MARK: - Private Functions
    private func enableEvents() {
        eventHandler.onError = { [weak self] in self?.onError($0) }

        router.get("ping") { try HTTPStatus.ok.encode(for: $0) }

        router.grouped(Printer()).post("event") { [unowned self] req -> Future<EventResponse> in
            return req.content.get(at: "type").flatMap { (type: String) -> Future<EventResponse> in
                let success = req.future(EventResponse.success)

                switch type {
                case "url_verification":
                    return try self.handleUrlVerification(req.content)

                case "event_callback":
                    let data = req.http.body.data ?? Data("{}".utf8)

                    DispatchQueue.global().async {
                        self.eventHandler.handle(data: data)
                    }

                    return success

                default:
                    self.onError(UnknownPacketError(type: type, packet: req.http.body.data.flatMap { String(data: $0, encoding: .utf8) }))
                    return success
                }
            }
        }
    }
    private func enableSlashCommands() {
        slashCommandHandler.onError = { [weak self] in self?.onError($0) }

        router.grouped(Printer()).post(["slashCommand", PathComponent.anything]) { [unowned self] req -> Future<EventResponse> in
            let success = req.future(EventResponse.success)

            if (try? req.content.syncGet(Int.self, at: "ssl_check")) != nil {
                return success
            }

            DispatchQueue.global().async {
                do {
                    let packet = try req.content.syncDecode(WithToken<SlashCommand>.self)
                    let data = try JSONEncoder().encode(packet)
                    self.slashCommandHandler.handle(data: data)

                } catch let error {
                    self.onError(error)
                }
            }

            return success
        }
    }
    private func handleUrlVerification(_ content: ContentContainer<Request>) throws -> Future<EventResponse> {
        struct Challenge: Decodable, Equatable {
            let token: String
            let challenge: String
            let type: String
        }

        return try content.decode(Challenge.self).map { [unowned self] challenge in
            guard challenge.token == self.verificationToken else { throw SlackPacketError.invalidToken }
            return .challenge(challenge.challenge)
        }
    }
}

private struct UnknownPacketError: Error, Equatable {
    let type: String
    let packet: String?
}

private enum EventResponse: ResponseEncodable {
    case challenge(String)
    case success

    func encode(for req: Request) throws -> EventLoopFuture<Response> {
        switch self {
        case .challenge(let value):
            return try value.encode(for: req)
        default:
            return try HTTPStatus.ok.encode(for: req)
        }
    }
}

private struct WithToken<T: Codable>: Codable {
    let token: String
    let value: T

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        self.token = try container.decode(String.self, forKey: "token")
        self.value = try T(from: decoder)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(token, forKey: "token")
        try value.encode(to: encoder)
    }
}
