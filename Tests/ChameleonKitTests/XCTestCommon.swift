import ChameleonKit
import XCTest

protocol ErrorContainer {
    var error: Error { get }
}

extension SlackEventError: ErrorContainer { }
extension SlashCommandError: ErrorContainer { }
extension SlashActionError: ErrorContainer { }

extension Error {
    func traverse(_ first: ErrorContainer.Type, _ rest: ErrorContainer.Type..., file: StaticString = #file, line: UInt = #line) -> Error? {
        let all = [first] + rest
        return all.reduce(Optional<Error>.some(self)) { error, type in
            error?.extract(ifType: type, file: file, line: line)
        }
    }

    private func extract(ifType type: ErrorContainer.Type, file: StaticString, line: UInt) -> Error? {
        guard let error = self as? ErrorContainer, Swift.type(of: error) == type else {
            XCTFail("Unexpected error type. Expected '\(type)' got '\(Swift.type(of: self))'", file: file, line: line)
            return nil
        }

        return error.error
    }
}
