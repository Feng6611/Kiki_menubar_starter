import AppKit
import KikiMenuBar

@MainActor
struct StarterMenuActions {
    let openSettings: () -> Void
    let openPaywall: () -> Void
    let toggleMockPro: () -> Void
    let resetMockState: () -> Void
    let quit: () -> Void
}

enum StarterMenuModel {
    @MainActor
    static func items(
        config: StarterAppConfig,
        entitlement: StarterEntitlementSnapshot,
        actions: StarterMenuActions
    ) -> [KikiMenuItem] {
        var items: [KikiMenuItem] = [
            .action(
                title: "\(config.appName): \(entitlement.accountStatus)",
                isEnabled: false,
                action: {}
            ),
            .separator,
            .settings(
                title: "Open Settings...",
                action: actions.openSettings
            ),
            .action(
                title: entitlement.isPro ? "Paywall unlocked" : "Open Paywall...",
                isEnabled: !entitlement.isPro,
                action: actions.openPaywall
            )
        ]

        #if DEBUG
        items.append(contentsOf: [
            .toggle(
                title: "Mock Pro",
                isOn: entitlement.isPro,
                action: actions.toggleMockPro
            ),
            .action(
                title: "Reset Mock State",
                isEnabled: entitlement.isPro || !entitlement.isTrialActive,
                action: actions.resetMockState
            )
        ])
        #endif

        items.append(contentsOf: [
            .separator,
            .quit(
                appName: config.appName,
                action: actions.quit
            )
        ])

        return items
    }
}
