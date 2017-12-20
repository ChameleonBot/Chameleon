
import Dispatch

extension SlackBot {
    /// Configure common HTTP routes
    func configureHTTPServer() {
        httpServer.register(.GET, path: ["hello"]) { (url, headers, body) -> HTTPServerResponse in
            return HTTPResponse.ok
        }

        //TODO add things like status page here.. maybe an admin console?
    }

    func startHTTPServer() {
        DispatchQueue.global().async {
            do {
                try self.httpServer.start()
            } catch let error {
                self.error(error)
            }
        }
    }
}
