
extension Conversation {
    public enum Event {
        case next(Segment)
        case retry([ChatMessageSegmentRepresentable])
        case cancel([ChatMessageSegmentRepresentable])
        case complete([ChatMessageSegmentRepresentable])
    }
}
