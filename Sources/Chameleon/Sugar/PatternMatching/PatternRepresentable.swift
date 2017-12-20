
/// Describes the different contexts patterns can be used in
public enum PatternContext {
    /// Can be used anywhere
    case any

    /// Can only be used in channels (including their threads)
    case `public`

    /// Can only be used in IMs
    case `private`
}

/// Defines an object that is representable as a pattern
public protocol PatternRepresentable {
    /// Sequence of `Matcher`s that make up a complete pattern
    var pattern: [Matcher] { get }

    /// The `PatternContext` this pattern will be available in
    var context: PatternContext { get }

    /// When `true` the pattern must match exactly, otherwise the pattern will 
    /// be surrounded by `String.any.orNone` `Matcher`s to allow a more flexible input
    ///
    /// - Default: `true`
    var strict: Bool { get }

    /// When `true` only admins will be able to trigger this pattern
    ///
    /// - Default: `false`
    var requiresAdmin: Bool { get }
}

extension PatternRepresentable {
    public var context: PatternContext { return .any }
    public var strict: Bool { return true }
    public var requiresAdmin: Bool { return false }
}

/// Function called when a pattern is matched, provides the bot instance as well as the message and matching pattern data
public typealias PatternHandler = (SlackBot, MessageDecorator, PatternMatch) throws -> Void

public extension SlackBot {
    /// Attempt to match the text from `message` against the provided `pattern`.
    /// if successful the supplied function is called with:
    /// - The `SlackBot` instance
    /// - The matched `MessageDecorator`
    /// - The `PatternMatch` data
    @discardableResult
    func route(_ message: MessageDecorator, matching pattern: PatternRepresentable, to closure: PatternHandler) throws -> Self {
        // stop early if this pattern requires admin and the user isn't one
        if try pattern.requiresAdmin && !(message.sender().value().is_admin) { return self }

        var pattern = pattern

        switch (pattern.context, message.isIM) {

        // check for invalid context
        case (.private, false):
            return self
        case (.public, true):
            return self

        // adjust pattern for target context
        case (.any, false), (.public, false):
            // don't add bot user to the start if it's already contained in the pattern
            // TODO : this predicate is a little ugly not to mention fragile... perhaps require `Matcher`s to be `Equatable` ?
            if pattern.pattern.contains(where: { $0 is BotUser && $0.matcherDescription == "(@\(me.name))" }) {
                break
            }
            pattern = pattern.preceed(with: [me, String.any.orNone])

        default:
            break
        }

        if let match = message.text.patternMatch(against: pattern.pattern, strict: pattern.strict) {
            try closure(self, message, match)
        }
        
        return self
    }
}

private struct WrappedPattern: PatternRepresentable {
    let pattern: [Matcher]
    let context: PatternContext
    let strict: Bool
    let requiresAdmin: Bool
}

public extension PatternRepresentable {
    /// Create a new `PatternRepresentable` in which the original pattern is preceeded by the supplied `Matcher`s
    func preceed(with matchers: [Matcher]) -> PatternRepresentable {
        return WrappedPattern(
            pattern: matchers + pattern,
            context: context,
            strict: strict,
            requiresAdmin: requiresAdmin
        )
    }

    /// Create a new `PatternRepresentable` in which the original pattern is preceeded by the supplied `Matcher`
    func preceed(with matcher: Matcher) -> PatternRepresentable {
        return preceed(with: [matcher])
    }
}
