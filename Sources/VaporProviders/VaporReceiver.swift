import ChameleonKit
import Vapor
import HTTP

public class VaporReceiver: SlackReceiver {
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

    struct EventHandler {
        typealias Processor = ([String: Any]) throws -> Any
        typealias Handler = (Any) throws -> Void

        let processor: Processor
        var handlers: [Handler]
    }

    private let application: Application
    private let router: Router
    private let verificationToken: String
    private var eventHandlers: [String: EventHandler] = [:]

    // MARK: - Lifecycle
    public init(application: Application, verificationToken: String) throws {
        self.application = application
        self.router = try application.make(Router.self)
        self.verificationToken = verificationToken

        //
        class Printer: Middleware {
            init() { }

            func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
//                print(request)
//                print("")
                return try next.respond(to: request)
            }
        }
        //

        router.grouped(Printer()).post("event") { [unowned self] req -> Future<EventResponse> in
            return req.content.get(at: "type").flatMap { (type: String) -> Future<EventResponse> in
                let success = req.future(EventResponse.success)

                switch type {
                case "url_verification":
                    return try self.handleUrlVerification(req.content)

                case "event_callback":
                    let data = req.http.body.data ?? Data("{}".utf8)

                    guard
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let token = json["token"] as? String
                        else { return success }

                    guard token == verificationToken else { return success }

                    guard
                        let event = json["event"] as? [String: Any],
                        let eventType = event["type"] as? String,
                        let handler = self.eventHandlers[eventType]
                        else { return success }

                    DispatchQueue.global().async {
                        do {
                            let processed = try handler.processor(event)
                            try handler.handlers.forEach { try $0(processed) }

                        } catch let error {
                            print("ERROR!!:", error)
                        }
                    }

                    return success

                default:
                    print("\nNO HANDLERS FOR EVENT: \(type)\n")
                    print(req.http.body.data.flatMap { String(data: $0, encoding: .utf8) } ?? "no data")
                    return success
                }
            }
        }
    }

    // MARK: - Public Functions
    public func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void) {
        var eventHandler = eventHandlers[event.type] ?? EventHandler(processor: event.handle, handlers: [])
        eventHandler.handlers.append({ try closure($0 as! T) })
        eventHandlers[event.type] = eventHandler
    }
    public func start() throws {
        try application.run()
    }

    // MARK: - Private Functions
    private func handleUrlVerification(_ content: ContentContainer<Request>) throws -> Future<EventResponse> {
        struct Challenge: Decodable, Equatable {
            enum Error: Swift.Error {
                case verificationFailed
            }

            let token: String
            let challenge: String
            let type: String
        }

        return try content.decode(Challenge.self).map { [verificationToken] challenge in
            guard challenge.token == verificationToken else { throw Challenge.Error.verificationFailed }
            return .challenge(challenge.challenge)
        }
    }
}
