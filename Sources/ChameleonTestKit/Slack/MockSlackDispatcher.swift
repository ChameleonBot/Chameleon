import ChameleonKit
import Foundation

enum PacketError: Error {
    case invalidPacket(String)
}

class MockSlackDispatcher: SlackDispatcher {
    private var queue: ArraySlice<Data> = []
    private let file: StaticString
    private let line: UInt

    var queueCount: Int { queue.count }
    var onPacket: (Encodable?) -> Void = { _ in }

    init(file: StaticString, line: UInt) {
        self.file = file
        self.line = line
    }

    func enqueue(_ fixture: FixtureSource<SlackDispatcher>) throws {
        try queue.append(fixture.data())
    }

    func perform<T>(_ action: SlackAction<T>) throws -> T {
        onPacket(action.packet)

        guard let data = queue.first else {
            let message = "Unable to perform '\(action.name)'. There are no items enqueued."
            _XCTFail(message, file: file, line: line)
            fatalError(message, file: file, line: line)
        }

        queue = queue.dropFirst()

        let json = try JSONSerialization.jsonObject(with: data, options: [])

        guard let packet = json as? [String: Any] else { throw SlackPacketError.invalidPacket(json) }

        return try action.handle(packet)
    }
}
