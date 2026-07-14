import Foundation
import KikiOnboarding
import KikiSettings

@MainActor
final class StarterAppComposition {
    let definition: StarterAppDefinition
    let settingsCoordinator: KikiSettingsCoordinator<StarterSettingsTab>
    let onboardingCompletionStore: KikiOnboardingCompletionStore

    lazy var onboardingCoordinator: KikiOnboardingCoordinator = {
        StarterOnboardingFeature.makeCoordinator(
            definition: definition,
            completionStore: onboardingCompletionStore,
            onOpenSettings: { [weak self] in
                self?.router.openSettings()
            }
        )
    }()

    lazy var router = StarterAppRouter(
        settingsCoordinator: settingsCoordinator,
        onboardingCoordinator: onboardingCoordinator
    )

    lazy var lifecycle = StarterAppLifecycleCoordinator(
        definition: definition,
        router: router
    )

    init(
        definition: StarterAppDefinition = .live,
        defaults: UserDefaults = .standard
    ) {
        self.definition = definition
        self.settingsCoordinator = KikiSettingsCoordinator(
            tabs: StarterSettingsTab.kikiTabs,
            initialTab: .general,
            windowController: KikiSettingsWindowController(
                frameAutosaveName: definition.settingsAutosaveName,
                minimumContentSize: CGSize(
                    width: KikiSettingsDefaults.minimumWindowWidth,
                    height: KikiSettingsDefaults.minimumWindowHeight
                )
            )
        )
        self.onboardingCompletionStore = KikiOnboardingUserDefaultsCompletionStore(
            defaults: defaults
        )
    }
}
