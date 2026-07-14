import Foundation

struct StarterOnboardingItem: Equatable {
    let systemImage: String
    let title: String
    let detail: String
}

struct StarterAppDefinition: Equatable {
    let appName: String
    let statusItemTitle: String
    let officialURL: URL
    let feedbackURL: URL
    let repositoryURL: URL

    let settingsAutosaveName: String
    let statusItemAutosaveName: String
    let onboardingCompletionKey: String
    let onboardingWindowAutosaveName: String

    let onboardingTitle: String
    let onboardingBody: String
    let onboardingItems: [StarterOnboardingItem]

    static let live = StarterAppDefinition(
        appName: "Kiki Starter",
        statusItemTitle: "Kiki",
        officialURL: URL(string: "https://example.com")!,
        feedbackURL: URL(string: "mailto:support@example.com")!,
        repositoryURL: URL(string: "https://github.com/Feng6611/Kiki_menubar_starter")!,
        settingsAutosaveName: "KikiMenubarStarter.SettingsWindow",
        statusItemAutosaveName: "KikiMenubarStarter.StatusItem",
        onboardingCompletionKey: "KikiMenubarStarter.Onboarding.hasCompleted",
        onboardingWindowAutosaveName: "KikiMenubarStarter.OnboardingWindow",
        onboardingTitle: "Start with the menu bar",
        onboardingBody: "Kiki Starter keeps its primary action in the menu bar and its controls in native Settings.",
        onboardingItems: [
            StarterOnboardingItem(
                systemImage: "menubar.rectangle",
                title: "Menu bar first",
                detail: "The app starts from a status item and stays out of the Dock."
            ),
            StarterOnboardingItem(
                systemImage: "gearshape",
                title: "Settings are the control surface",
                detail: "Put behavior, startup, recovery, and About content there."
            ),
            StarterOnboardingItem(
                systemImage: "checkmark.seal",
                title: "Keep the template small",
                detail: "Add product-specific permissions, services, or paid access only when the app needs them."
            )
        ]
    )
}
