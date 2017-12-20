
import Dispatch
import Foundation

extension RTMAPI {
    func startPingPong() {
        let ping = DispatchWorkItem {
            self.sendPing()
            self.startPingPong()
        }

        pingPong?.cancel()
        pingPong = ping
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0, execute: ping)
    }
    func stopPingPong() {
        pingPong?.cancel()
    }

    private func sendPing() {
        //`timestamp` will come back in the response
        //could potentially be used later for checking
        //latency as suggested in the docs

        let ping: [String: Any] = [
            "id": Int.random(min: 1, max: 999999),
            "type": "ping",
            "timestamp": Int(Date().timeIntervalSince1970)
        ]

        try? socket.send(packet: ping)
    }
}
