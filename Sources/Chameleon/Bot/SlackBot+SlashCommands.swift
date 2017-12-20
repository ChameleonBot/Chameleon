
enum SlashCommandError: Swift.Error {
    case missingVerificationToken
    case invalidVerificationToken
}

private extension String {
    var normalizedSlashCommand: String {
        return lowercased().remove(prefix: "/")
    }
}

private extension SlashCommandSource {
    var normalizedSlashCommand: String {
        switch self {
        case .app(let command):
            return command.normalizedSlashCommand
        case .team(let command, _):
            return command.normalizedSlashCommand
        }
    }
}

extension SlackBot {
    /// Configure slash command HTTP route
    func configureSlashCommands() {
        httpServer.register(.POST, path: ["slashCommand"]) { [weak self] (url, headers, body) -> HTTPServerResponse in
            guard let this = self else { return HTTPResponse.ok }

            do {
                let command = try SlashCommand(decoder: Decoder(data: body))

                let services = this.services
                    .lazy
                    .flatMap { $0 as? SlackBotSlashCommandService }
                    .map { ($0, $0.slashCommands) }

                for (service, commandSources) in services {
                    for source in commandSources {
                        guard source.normalizedSlashCommand == command.command.normalizedSlashCommand
                            else { continue }

                        switch source {
                        case .app:
                            guard let token = this.config.verificationToken
                                else { throw SlashCommandError.missingVerificationToken }

                            guard token == command.token else { continue }

                            try service.onSlashCommand(slackBot: this, command: command)

                        case .team(_, let token):
                            guard token == command.token else { continue }

                            try service.onSlashCommand(slackBot: this, command: command)
                        }
                    }
                }
                
            } catch let error {
                this.error(error)
            }
            
            return HTTPResponse.ok
        }
    }
}
