import AppKit
import KikiOnboarding
import KikiSettings

@MainActor
final class StarterAppRouter {
    private let settingsCoordinator: KikiSettingsCoordinator<StarterSettingsTab>
    private let onboardingCoordinator: KikiOnboardingCoordinator
    private let quitApplication: () -> Void

    init(
        settingsCoordinator: KikiSettingsCoordinator<StarterSettingsTab>,
        onboardingCoordinator: KikiOnboardingCoordinator,
        quitApplication: (() -> Void)? = nil
    ) {
        self.settingsCoordinator = settingsCoordinator
        self.onboardingCoordinator = onboardingCoordinator
        self.quitApplication = quitApplication ?? { NSApp.terminate(nil) }
    }

    func openSettings(tab: StarterSettingsTab = .general) {
        settingsCoordinator.open(tab: tab)
    }

    func showOnboardingIfNeeded() {
        onboardingCoordinator.startIfNeeded()
    }

    func restartOnboarding() {
        onboardingCoordinator.resetCompletion()
        onboardingCoordinator.start()
    }

    func quit() {
        quitApplication()
    }
}
