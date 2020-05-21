import ChameleonKit
import Vapor

extension SlackBot {
    public static func vaporBased(verificationToken: String, accessToken: String) throws -> SlackBot {
        let application = try Application()
        let webApi = try VaporDispatcher(application: application, token: accessToken)
        let eventApi = try VaporReceiver(application: application, verificationToken: verificationToken)
        return .init(dispatcher: webApi, receiver: eventApi)
    }
}
