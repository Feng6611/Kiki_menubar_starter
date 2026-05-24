import Foundation

struct StarterAppConfig: Equatable {
    let appName: String
    let statusItemTitle: String
    let includesPaidAccess: Bool
    let officialURL: String
    let officialDisplayName: String
    let contactEmailAddress: String
    let contactEmailURL: String
    let repositoryURL: String
    let repositoryDisplayName: String
    let plans: [StarterPlanConfig]
    let features: [String]
    let stats: [StarterStatConfig]

    static let `default` = StarterAppConfig(
        appName: "Kiki Starter",
        statusItemTitle: "Kiki",
        includesPaidAccess: true,
        officialURL: "https://example.com",
        officialDisplayName: "example.com",
        contactEmailAddress: "support@example.com",
        contactEmailURL: "mailto:support@example.com",
        repositoryURL: "https://github.com/Feng6611/Kiki_menubar_starter",
        repositoryDisplayName: "Feng6611/Kiki_menubar_starter",
        plans: [
            StarterPlanConfig(
                id: "monthly",
                title: "Monthly",
                displayPrice: "$4.99",
                originalPrice: nil,
                billingDetail: "per month",
                badge: nil
            ),
            StarterPlanConfig(
                id: "lifetime",
                title: "Lifetime",
                displayPrice: "$24.99",
                originalPrice: "$39.99",
                billingDetail: "one-time purchase",
                badge: "Best value"
            )
        ],
        features: [
            "Menu bar first app shell",
            "Reusable settings window",
            "Optional paid access and paywall flow"
        ],
        stats: [
            StarterStatConfig(value: "3", label: "Kiki modules"),
            StarterStatConfig(value: "0", label: "SDK keys")
        ]
    )

    func withPaidAccess(_ includesPaidAccess: Bool) -> StarterAppConfig {
        StarterAppConfig(
            appName: appName,
            statusItemTitle: statusItemTitle,
            includesPaidAccess: includesPaidAccess,
            officialURL: officialURL,
            officialDisplayName: officialDisplayName,
            contactEmailAddress: contactEmailAddress,
            contactEmailURL: contactEmailURL,
            repositoryURL: repositoryURL,
            repositoryDisplayName: repositoryDisplayName,
            plans: plans,
            features: features,
            stats: stats
        )
    }
}
