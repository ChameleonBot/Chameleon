import ChameleonKit
import Foundation

class MockSlackDispatcher: SlackDispatcher {
    private var queue: ArraySlice<Data> = []
    private let file: StaticString
    private let line: UInt

    var queueCount: Int { queue.count }

    init(file: StaticString, line: UInt) {
        self.file = file
        self.line = line
    }

    func enqueue(_ fixture: FixtureSource<SlackDispatcher>) throws {
        try queue.append(fixture.data())
    }

    func perform<T>(_ action: SlackAction<T>) throws -> T {
        guard let data = queue.first else {
            let message = "Unable to perform '\(action.name)'. There are no items enqueued."
            _XCTFail(message, file: file, line: line)
            fatalError(message, file: file, line: line)
        }

        queue = queue.dropFirst()

        guard
            let packet = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else { throw SlackPacketError.invalidPacket }

        return try action.handle(packet)
    }
}
