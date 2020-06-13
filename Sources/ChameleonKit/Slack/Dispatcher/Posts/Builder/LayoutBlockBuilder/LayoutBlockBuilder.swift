public struct LayoutBlockBuilder<Context> {
    let setup: (SlackReceiver) -> Void
    let build: () -> LayoutBlock

    init(setup: @escaping (SlackReceiver) -> Void = { _ in }, build: @escaping () -> LayoutBlock) {
        self.setup = setup
        self.build = build
    }

}
