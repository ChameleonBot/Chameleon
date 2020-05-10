import Foundation

public protocol ImageContext { }
extension Message.Layout.Section: ImageContext { }
extension Message.Layout.Context: ImageContext { }

extension BlockElementBuilder where Context: ImageContext {
    public static func image(image_url: URL, alt_text: String) -> BlockElementBuilder {
        return .init {
            return Image(type: Image.type, image_url: image_url, alt_text: alt_text)
        }
    }
}
