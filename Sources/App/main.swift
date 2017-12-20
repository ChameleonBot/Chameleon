/*
import Chameleon

let storage = PListStorage()
let store = MemoryKeyValueStore()

store.set(value: <#VALUE#>, forKey: "CLIENT_ID")
store.set(value: <#VALUE#>, forKey: "CLIENT_SECRET")
store.set(value: <#VALUE#>, forKey: "REDIRECT_URI")

let authenticator = OAuthAuthenticator(
    network: NetworkProvider(),
    storage: storage,
    clientId: try store.get(forKey: "CLIENT_ID"),
    clientSecret: try store.get(forKey: "CLIENT_SECRET"),
    scopes: [.channels_write, .chat_write_bot, .users_read],
    redirectUri: try? store.get(forKey: "REDIRECT_URI")
)

let bot = SlackBot(
    authenticator: authenticator,
    services: []
)

bot.on(message.self) { bot, data in
    let msg = data.message.makeDecorator()

    guard msg.text.patternMatches(against: ["hello"]) else { return }

    try bot.send(["hey!"], to: msg.target())
}

bot.start()
*/

//// MUSTARD
//store.set(value: "4962332711.68953359462", forKey: "CLIENT_ID")
//store.set(value: "b01bcb34a219518fe761dd5ae0d4cdf4", forKey: "CLIENT_SECRET")
//store.set(value: "https://chameleon.localtunnel.me/oauth", forKey: "REDIRECT_URI")
//
////// IOS-DEV-HQ
////store.set(value: "2929213690.80758910225", forKey: "CLIENT_ID")
////store.set(value: "cfc623810b44a64afb24c496e1bc3988", forKey: "CLIENT_SECRET")

