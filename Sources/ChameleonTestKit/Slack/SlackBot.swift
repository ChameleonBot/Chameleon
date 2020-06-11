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
        public var sentPackets: [[String: Any]] { dispatcher.packets }

        let dispatcher: MockSlackDispatcher
        let receiver: MockSlackReceiver

        init(_ bot: SlackBot, _ dispatcher: MockSlackDispatcher, _ receiver: MockSlackReceiver, _ errors: Errors) {
            self.bot = bot
            self.dispatcher = dispatcher
            self.receiver = receiver
            self.errors = errors
        }

        public func send(_ fixture: FixtureSource<SlackReceiver>) throws {
            try receiver.receive(fixture)
        }
        public func send(_ incoming: FixtureSource<SlackReceiver>, enqueue responses: [FixtureSource<SlackDispatcher>]) throws {
            try enqueue(responses)
            try send(incoming)
        }
        public func enqueue(_ fixtures: [FixtureSource<SlackDispatcher>]) throws {
            try fixtures.forEach(dispatcher.enqueue)
        }
    }

    public static func test(file: StaticString = #file, line: UInt = #line) throws -> Test {
        let errors = Errors()
        let dispatcher = MockSlackDispatcher(file: file, line: line)
        let receiver = MockSlackReceiver()
        
        try dispatcher.enqueue(.authDetails())
        try dispatcher.enqueue(.usersInfo(.bot()))

        let bot = SlackBot(dispatcher: dispatcher, receiver: receiver)
        bot.listen(for: .error) { errors.append($1) }
        try bot.start()

        return .init(bot, dispatcher, receiver, errors)
    }
}
