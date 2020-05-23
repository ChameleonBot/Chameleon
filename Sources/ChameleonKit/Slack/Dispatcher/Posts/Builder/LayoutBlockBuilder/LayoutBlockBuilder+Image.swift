import Foundation

public protocol ImageLayoutContext { }
extension ModalSurface: ImageLayoutContext { }
extension MessagesSurface: ImageLayoutContext { }
extension HomeTabSurface: ImageLayoutContext { }

extension LayoutBlockBuilder where Context: ImageLayoutContext {
    public static func image(block_id: String? = nil, image_url: URL, alt_text: String, title: Text.PlainText? = nil) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.Image(type: Message.Layout.Image.type, image_url: image_url, alt_text: alt_text, title: title, block_id: block_id)
        }
    }
}
