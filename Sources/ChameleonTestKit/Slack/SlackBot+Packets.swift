public class Packets {
    private var packets: [Encodable] = []

    public var count: Int { packets.count }

    public func append(_ packet: Encodable?) {
        guard let packet = packet else { return }

        packets.append(packet)
    }

    public func first<T: Encodable>(_: T.Type = T.self) -> T? {
        return packets.first as? T
    }
    public func item<T: Encodable>(_: T.Type = T.self, at index: Int) -> T? {
        guard packets.indices.contains(index) else { return nil }
        
        return packets[index] as? T
    }
    public func last<T: Encodable>(_: T.Type = T.self) -> T? {
        return packets.last as? T
    }
}
