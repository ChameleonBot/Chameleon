/*
import ChameleonKit
import VaporProviders

let storage = PListStorage()
let store = MemoryKeyValueStorage()

store.set(value: <#VALUE#>, forKey: "VERIFICATION_TOKEN")
store.set(value: <#VALUE#>, forKey: "API_TOKEN")

let bot = try SlackBot
    .vaporBased(
       verificationToken: try store.get(forKey: "VERIFICATION_TOKEN"),
       accessToken: try store.get(forKey: "API_TOKEN")
    )

bot.listen(for: .message) { bot, message in
    try message.matching("hello " && .user(bot.me)) { _ in
    try bot.perform(.respond(to: message, .inline, with: "Hi!!"))
}

try bot.start()
*/
