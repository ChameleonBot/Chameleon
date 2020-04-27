import Foundation

extension SlackEvent {
    public static var message: SlackEvent<Message> {
        return .init(type: "message") { json in
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

            let data = try JSONSerialization.data(withJSONObject: newMessage, options: [])
            return try JSONDecoder().debug(json).decode(Message.self, from: data)
        }
    }
}
