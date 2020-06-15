import Foundation

extension SlackEvent {
    public static var message: SlackEvent<Message> {
        return .init(
            identifier: "message",
            canHandle: { type, json in
                guard type == "message" else { return false }
                guard let subtype = json["subtype"] as? String else { return true }

                switch subtype {
                case "message_changed":
                    // some "message_changed" events also have "message.subtype" = "tombstone"
                    // these come through when a message is deleted but has replies
                    // so the 'tombstone' takes the original messages place.
                    // these should trigger the `.messageDeleted` event, not `.message`
                    guard
                        let message = json["message"] as? [String: Any],
                        let innerSubtype = message["subtype"] as? String
                        else { return true }

                    return innerSubtype != "tombstone"

                case "thread_broadcast", "message_replied":
                    return true

                default:
                    return false
                }
            },
            handler: { json in
                // json message data can exist inside root keys:
                // - message
                // - root
                //
                // previous message data can exist inside root key:
                // - previous_message
                //
                // `message` and `previous_message` could _also_ have a key named `root` with needed info
                // (the initial squash will pull the `root` key down (if it exists) so we can make a second pass)

                var newMessage = json
                newMessage.squash(from: "message")
                newMessage.squash(from: "root")

                if json["previous_message"] != nil {
                    var oldMessage = json
                    oldMessage.squash(from: "previous_message")
                    oldMessage.squash(from: "root")
                    newMessage["previous"] = oldMessage
                }

                return try Message(from: newMessage, decoder: JSONDecoder().debug(json))
            }
        )
    }
}
