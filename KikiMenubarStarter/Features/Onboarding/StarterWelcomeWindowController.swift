import AppKit
import KikiWindow

@MainActor
final class StarterWelcomeWindowController {
    private let config: StarterAppConfig
    private let onboardingState: StarterOnboardingState
    private let openSettings: () -> Void
    private var isCompletingIntentionally = false

    private lazy var windowController = KikiSingleWindowController(
        configuration: .utility(
            title: "Welcome",
            size: CGSize(width: 560, height: 500),
            minimumSize: CGSize(width: 520, height: 460),
            frameAutosaveName: "KikiMenubarStarter.OnboardingWindow"
        ),
        onClose: { [weak self] in
            self?.handleWindowClose()
        }
    ) { [weak self, config] in
        StarterWelcomeView(
            config: config,
            onOpenSettings: {
                self?.finish()
                self?.openSettings()
            },
            onFinish: {
                self?.finish()
            }
        )
    }

    init(
        config: StarterAppConfig,
        onboardingState: StarterOnboardingState,
        openSettings: @escaping () -> Void
    ) {
        self.config = config
        self.onboardingState = onboardingState
        self.openSettings = openSettings
    }

    func showIfNeeded() {
        guard onboardingState.shouldShowOnboarding else {
            return
        }

        windowController.show()
    }

    private func finish() {
        isCompletingIntentionally = true
        onboardingState.complete()
        windowController.close()
    }

    private func handleWindowClose() {
        guard !isCompletingIntentionally else {
            isCompletingIntentionally = false
            return
        }

        onboardingState.complete()
    }
}
