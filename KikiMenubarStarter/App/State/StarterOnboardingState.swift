import Foundation

@MainActor
final class StarterOnboardingState {
    private enum Keys {
        static let hasCompletedOnboarding = "KikiMenubarStarter.Onboarding.hasCompleted"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var hasCompletedOnboarding: Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }

    var shouldShowOnboarding: Bool {
        !hasCompletedOnboarding
    }

    func complete() {
        defaults.set(true, forKey: Keys.hasCompletedOnboarding)
    }

    func resetForTesting() {
        defaults.removeObject(forKey: Keys.hasCompletedOnboarding)
    }
}
