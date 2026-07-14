import Foundation

struct StarterAppConfig: Equatable {
    let appName: String
    let statusItemTitle: String
    let officialURL: String
    let officialDisplayName: String
    let contactEmailAddress: String
    let repositoryURL: String
    let repositoryDisplayName: String

    static let `default` = StarterAppConfig(
        appName: "Kiki Starter",
        statusItemTitle: "Kiki",
        officialURL: "https://example.com",
        officialDisplayName: "example.com",
        contactEmailAddress: "support@example.com",
        repositoryURL: "https://github.com/Feng6611/Kiki_menubar_starter",
        repositoryDisplayName: "Feng6611/Kiki_menubar_starter"
    )
}
