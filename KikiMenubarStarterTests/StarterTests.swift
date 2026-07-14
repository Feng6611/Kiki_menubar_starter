import KikiMenuBar
import XCTest
@testable import KikiMenubarStarter

@MainActor
final class StarterTests: XCTestCase {
    func testMenuModelIsFreeByDefault() {
        let items = StarterMenuModel.items(
            config: .default,
            actions: noOpActions
        )

        XCTAssertEqual(items.compactMap(\.title), [
            "Open Settings...",
            "Quit Kiki Starter"
        ])
    }

    func testOnboardingStateCompletesAndResets() {
        let defaults = isolatedDefaults()
        let state = StarterOnboardingState(defaults: defaults)

        XCTAssertFalse(state.hasCompletedOnboarding)
        XCTAssertTrue(state.shouldShowOnboarding)

        state.complete()

        XCTAssertTrue(state.hasCompletedOnboarding)
        XCTAssertFalse(state.shouldShowOnboarding)

        state.resetForTesting()

        XCTAssertFalse(state.hasCompletedOnboarding)
        XCTAssertTrue(state.shouldShowOnboarding)
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
