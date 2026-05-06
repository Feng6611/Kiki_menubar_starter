import Foundation
import KikiPaywall

struct StarterAppConfig: Equatable {
    let appName: String
    let statusItemTitle: String
    let supportURL: String
    let privacyURL: String
    let repositoryURL: String
    let plans: [StarterPlanConfig]
    let features: [String]
    let stats: [StarterStatConfig]

    static let `default` = StarterAppConfig(
        appName: "Kiki Starter",
        statusItemTitle: "Kiki",
        supportURL: "https://github.com/Feng6611/Kiki_mackit",
        privacyURL: "https://example.com/privacy",
        repositoryURL: "https://github.com/Feng6611/Kiki_menubar_starter",
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
            "Mock entitlement and paywall flow"
        ],
        stats: [
            StarterStatConfig(value: "3", label: "Kiki modules"),
            StarterStatConfig(value: "0", label: "SDK keys")
        ]
    )
}

struct StarterPlanConfig: Equatable, Identifiable {
    let id: String
    let title: String
    let displayPrice: String
    let originalPrice: String?
    let billingDetail: String
    let badge: String?

    var kikiPaywallPlan: KikiPaywallPlan {
        KikiPaywallPlan(
            id: id,
            title: title,
            displayPrice: displayPrice,
            originalPrice: originalPrice,
            billingDetail: billingDetail,
            badge: badge
        )
    }
}

struct StarterStatConfig: Equatable {
    let value: String
    let label: String
}
