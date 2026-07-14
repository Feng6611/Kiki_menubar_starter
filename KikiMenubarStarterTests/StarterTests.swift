import KikiMenuBar
import KikiOnboarding
import XCTest
@testable import KikiMenubarStarter

@MainActor
final class StarterTests: XCTestCase {
    func testMenuModelIsFreeByDefault() {
        let items = StarterMenuModel.items(
            definition: .live,
            actions: noOpActions
        )

        XCTAssertEqual(items.compactMap(\.title), [
            "Open Settings...",
            "Quit Kiki Starter"
        ])
    }

    func testCompositionOwnsFeatureCoordinatorsAndStableKeys() {
        let defaults = isolatedDefaults()
        let composition = StarterAppComposition(defaults: defaults)

        XCTAssertEqual(composition.settingsCoordinator.tabs.map(\.tab), [.general, .about])
        XCTAssertEqual(
            composition.onboardingCoordinator.configuration.completionKey,
            StarterAppDefinition.live.onboardingCompletionKey
        )
        XCTAssertEqual(composition.onboardingCoordinator.currentStep?.id, "custom.starter-welcome")
        XCTAssertFalse(composition.onboardingCoordinator.isCompleted)

        composition.onboardingCoordinator.finish()

        XCTAssertTrue(composition.onboardingCoordinator.isCompleted)

        composition.onboardingCoordinator.resetCompletion()

        XCTAssertFalse(composition.onboardingCoordinator.isCompleted)
    }

    private var noOpActions: StarterMenuActions {
        StarterMenuActions(
            openSettings: {},
            quit: {}
        )
    }

    private func isolatedDefaults() -> UserDefaults {
        let suiteName = "dev.kkuk.kikistarter.tests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
