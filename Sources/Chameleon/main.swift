import ChameleonKit
import VaporProviders
import Vapor
import Foundation

let verificationToken = "***REMOVED***"
let apiToken = "***REMOVED***"

let application = try Application()
let eventApi = try VaporReceiver(application: application, verificationToken: verificationToken)
let webApi = try VaporDispatcher(application: application, token: apiToken)

var me: User!

struct KarmaModifier {
    let update: (Int) -> Int
}

extension ElementMatcher {
    static var karma: ElementMatcher {
        let plusOne = ElementMatcher.contains("++").map(KarmaModifier { $0 + 1 })
        let plusN = ElementMatcher(parser: "+=" *> .integer, stripWhitespace: true).map { n in KarmaModifier { $0 + n } }

        let minusOne = ElementMatcher.contains("--").map(KarmaModifier { $0 - 1 })
        let minusN = ElementMatcher(parser: "-=" *> .integer, stripWhitespace: true).map { n in KarmaModifier { $0 - n } }

        return plusOne || plusN || minusOne || minusN
    }
}

extension ElementMatcher {
    init<T>(parser: Parser<T>, stripWhitespace: Bool = false) {
        self.init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Text else { return nil }

            let text = stripWhitespace
                ? element.text.replacingOccurrences(of: " ", with: "")
                : element.text

            return parser.parse(text[...]).map { ([$0.value], elements.dropFirst()) }
        }
    }
}

var counts: [Identifier<User>: Int] = [:]

eventApi.listen(for: .message) { message in
    if me == nil {
        let auth = try webApi.perform(.authDetails)
        me = try webApi.perform(.user(auth.user_id))
    }

    // KARMA EXAMPLE
    guard !message.hidden else { return }

    typealias KarmaMatch = (Identifier<User>, KarmaModifier)

    try message.richText().matching([^.user(me), " how much karma do I have"]) {
        try webApi.perform(.speak(in: message.channel, "Your karma is at: \(counts[message.user, default: 0])"))
    }

    try message.richText().matchingAll([.user, .karma]) { (updates: [KarmaMatch]) in
        for update in updates {
            let current = counts[update.0, default: 0]
            let new = update.1.update(current)
            counts[update.0] = new
            print(update.0, "updated to:", new)
        }
    }
}
try eventApi.start()
