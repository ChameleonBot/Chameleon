import Foundation

public struct BlockElementBuilder<Context> {
    let build: () -> BlockElement
}
