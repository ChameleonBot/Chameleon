import ChameleonKit
import Foundation

public func XCTAssertClear(_ test: SlackBot.Test, file: StaticString = #file, line: UInt = #line) {
    guard test.dispatcher.queueCount == 0 else {
        return _XCTFail("Dispatcher actions have not been exhausted. \(test.dispatcher.queueCount) remaining", file: file, line: line)
    }
    guard test.errors.count == 0 else {
        return _XCTFail("Unexpected errors. \(test.errors.count) total\n\(test.errors)", file: file, line: line)
    }
}

extension SlackBot {
    public struct Test {
        public let bot: SlackBot
        public let errors: Errors

        let dispatcher: MockSlackDispatcher
        let receiver: MockSlackReceiver

        init(_ bot: SlackBot, _ dispatcher: MockSlackDispatcher, _ receiver: MockSlackReceiver, _ errors: Errors) {
            self.bot = bot
            self.dispatcher = dispatcher
            self.receiver = receiver
            self.errors = errors
        }

        public func send<T>(_ fixture: FixtureSource<SlackReceiver, T>) throws {
            try receiver.receive(fixture)
        }
        public func send<T, U>(_ incoming: FixtureSource<SlackReceiver, T>, enqueue outgoing: FixtureSource<SlackDispatcher, U>) throws {
            try enqueue(outgoing)
            try send(incoming)
        }
        public func enqueue<T>(_ fixture: FixtureSource<SlackDispatcher, T>) throws {
            try dispatcher.enqueue(fixture)
        }
    }

    public static func test(file: StaticString = #file, line: UInt = #line) throws -> Test {
        let errors = Errors()
        let dispatcher = MockSlackDispatcher(file: file, line: line)
        let receiver = MockSlackReceiver()
        
        try dispatcher.enqueue(.authDetails())
        try dispatcher.enqueue(.bot())

        let bot = SlackBot(dispatcher: dispatcher, receiver: receiver)
        bot.listen(for: .error) { errors.append($1) }
        try bot.start()

        return .init(bot, dispatcher, receiver, errors)
    }
}

public class Errors: Equatable, CustomStringConvertible {
    private var errors: [Error] = []

    public var count: Int { errors.count }
    public func append(_ error: Error) { errors.append(error) }

    public static func ==(lhs: Errors, rhs: Errors) -> Bool {
        return lhs.errors.map(errorString) == rhs.errors.map(errorString)
    }

    public var description: String {
        return errors.map(errorString).joined(separator: "\n")
    }
}

private func errorString(_ error: Error) -> String {
    return "\(String(describing: error)):\(String(reflecting: error))"
}
