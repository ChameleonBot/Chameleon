import ChameleonKit
import Vapor


//
private class Printer: Middleware {
    init() { }

	func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
		print(request)
		print("")
		return next.respond(to: request)
	}
}
//

public class VaporReceiver: SlackReceiver {
    // MARK: - Private Properties
    private let application: Application
    private let verificationToken: String
    private let eventHandler: SlackEventHandler
    private let slashCommandHandler: SlashCommandHandler
    private let interactionHandler: InteractionHandler

    // MARK: - Public Properties
    public var onError: (Error) -> Void = { print("\nVaporReceiver Error:", $0) }

    // MARK: - Lifecycle
    public init(application: Application, verificationToken: String) throws {
        self.application = application
        self.verificationToken = verificationToken
        self.eventHandler = SlackEventHandler(verificationToken: verificationToken)
        self.slashCommandHandler = SlashCommandHandler(verificationToken: verificationToken)
        self.interactionHandler = InteractionHandler(verificationToken: verificationToken)

		application.get("ping") { request in
			return HTTPStatus.ok.encodeResponse(for: request)
		}

        enableEvents()
        enableSlashCommands()
        enableInteractions()
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

    public func registerAction(id: String, closure: @escaping (Interaction) throws -> Void) {
        interactionHandler.registerAction(id: id, closure: closure)
    }

    public func start() throws {
        try application.run()
    }

    // MARK: - Private Functions
    private func enableEvents() {
        eventHandler.onError = { [weak self] in self?.onError($0) }

        application.grouped(Printer()).post("event") { [unowned self] req throws -> EventLoopFuture<EventResponse> in
			let type = try req.content.get(String.self, at: "type")

			switch type {
			case "url_verification":
				return try self.handleUrlVerification(req.content, req: req)

			case "event_callback":
				let data = req.body.data?.asData ?? Data("{}".utf8)

				DispatchQueue.global().async {
					self.eventHandler.handle(data: data)
				}

				return req.eventLoop.makeSucceededFuture(EventResponse.success)

			default:
				self.onError(UnknownPacketError(type: type, packet: req.body.data?.asData.flatMap { String(data: $0, encoding: .utf8) }))
				return req.eventLoop.makeSucceededFuture(EventResponse.success)
			}

        }
    }
    private func enableSlashCommands() {
        slashCommandHandler.onError = { [weak self] in self?.onError($0) }

		application.grouped(Printer()).post(["slashCommand", PathComponent.anything]) { [unowned self] req -> EventLoopFuture<EventResponse> in
            if (try? req.content.get(Int.self, at: "ssl_check")) != nil {
				return req.eventLoop.makeSucceededFuture(EventResponse.success)
            }

            DispatchQueue.global().async {
                do {
					let packet = try req.content.decode(WithToken<SlashCommand>.self)
                    let data = try JSONEncoder().encode(packet)
                    self.slashCommandHandler.handle(data: data)

                } catch let error {
                    self.onError(error)
                }
            }

			return req.eventLoop.makeSucceededFuture(EventResponse.success)
        }
    }
    private func enableInteractions() {
        interactionHandler.onError = { [weak self] in self?.onError($0) }

        application.grouped(Printer()).post("interaction") { [unowned self] req -> EventLoopFuture<Response> in
            let data = try Data(req.content.get(String.self, at: "payload").utf8)

            DispatchQueue.global().async {
                self.interactionHandler.handle(data: data)
            }

			return HTTPStatus.ok.encodeResponse(for: req)
        }

    }
	private func handleUrlVerification(_ content: ContentContainer, req: Request) throws -> EventLoopFuture<EventResponse> {
        struct Challenge: Decodable, Equatable {
            let token: String
            let challenge: String
            let type: String
        }

		let challenge = try content.decode(Challenge.self)

		guard challenge.token == self.verificationToken else { throw SlackPacketError.invalidToken([:]) }
		return req.eventLoop.makeSucceededFuture(.challenge(challenge.challenge))
    }
}

private struct UnknownPacketError: Error, Equatable {
    let type: String
    let packet: String?
}

private enum EventResponse: ResponseEncodable {
    case challenge(String)
    case success

	func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
		switch self {
		case .challenge(let value):
			return value.encodeResponse(for: request)
		default:
			return HTTPStatus.ok.encodeResponse(for: request)
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

private extension ByteBuffer {
	var asData: Data? {
		return Data(readableBytesView)
	}
}
