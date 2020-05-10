public protocol RichTextTeamContext { }
extension Message.Layout.RichText.Section: RichTextTeamContext { }
extension Message.Layout.RichText.Quote: RichTextTeamContext { }

extension RichTextElementBuilder where Context: RichTextTeamContext {
    public static func team(_ value: Identifier<Team>) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.Team(type: Message.Layout.RichText.Element.Team.type, team_id: value)
        }
    }
}
