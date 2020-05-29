import ChameleonKit

extension SlackBot.Recording {
    static func sanitize(bot: User, _ packets: [[String: Any]]) -> [[String: Any]] {
        var result: [[String: Any]] = []
        let store = SanitationStore()
        store.preload(bot.id.rawValue)

        for index in packets.indices {
            var packet = packets[index]

            packet["client_msg_id"] = nil
            packet.replaceValues { key, value in
                switch key {
                case "app_id":
                    return "A0000000000"
                case "team", "team_id":
                    return "T00000000"
                case "user", "user_id", "channel", "id", "bot_id":
                    return store.value(value)
                default:
                    return value
                }
            }

            if let text = packet["text"] as? String {
                packet["text"] = store.sanitize(text)
            }

            result.append(packet)
        }

        return result
    }
}

class SanitationStore {
    private var allValues: [Character: [String: String]] = [:]

    func preload(_ key: String) {
        _ = value(key)
    }

    func value(_ value: String) -> String {
        let prefix = value[value.startIndex]
        var values = allValues[prefix, default: [:]]

        if let result = values[value] {
            return result

        } else {
            let newId = "\(values.count)"
            let id = "\(prefix)\(String(repeating: "0", count: 10 - newId.count))\(newId)"
            values[value] = id
            allValues[prefix] = values
            return id
        }
    }

    func sanitize(_ text: String) -> String {
        var text = text

        let allPairs = allValues.values.flatMap { dict in
            return dict.keys.map { ($0, dict[$0]!) }
        }
        for (original, replacement) in allPairs {
            text = text.replacingOccurrences(of: original, with: replacement)
        }

        return text
    }
}

private extension Dictionary where Key == String, Value == Any {
    mutating func replaceValues(_ closure: (_ key: String, _ value: String) -> String) {
        for key in keys {
            switch self[key] {
            case var value as [String: Any]:
                value.replaceValues(closure)
                self[key] = value

            case var values as [[String: Any]]:
                for index in values.indices {
                    values[index].replaceValues(closure)
                }
                self[key] = values

            case let value as String:
                self[key] = closure(key, value)

            default:
                break
            }
        }
    }
}
