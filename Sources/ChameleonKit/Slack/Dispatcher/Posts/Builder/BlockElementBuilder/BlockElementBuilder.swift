import Foundation

public struct BlockElementBuilder<Context> {
    let setup: (SlackReceiver) -> Void
    let build: () -> BlockElement

    init(setup: @escaping (SlackReceiver) -> Void = { _ in }, build: @escaping () -> BlockElement) {
        self.setup = setup
        self.build = build
    }
}
