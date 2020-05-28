import Foundation

extension SlackAction {
    private struct FilePacket: Encodable {
        //
        // TODO: Upload files and images into message threads by providing the thread parent's `ts` value with the `thread_ts` parameter.
        //
        @CSV var channels: [Identifier<Channel>]
        var content: Data
        var filename: String?
        var filetype: FileType?
        var title: String?
        var initial_comment: String?
    }

    public static func upload(channels: [Identifier<Channel>], filename: String? = nil, filetype: FileType? = nil, title: String? = nil, initialComment: String? = nil, _ data: Data) throws -> SlackAction<File> {
        let packet = FilePacket(channels: channels, content: data, filename: filename, filetype: filetype, title: title, initial_comment: initialComment)
        return .init(name: "files.upload", method: .post, encoding: .formData, packet: packet)
    }
}
