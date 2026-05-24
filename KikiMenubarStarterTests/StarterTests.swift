import KikiMenuBar
import XCTest
@testable import KikiMenubarStarter

@MainActor
final class StarterTests: XCTestCase {
    func testMenuModelForFreeUser() {
        let items = StarterMenuModel.items(
            config: .default,
            entitlement: StarterEntitlementSnapshot(isPro: false, isTrialActive: true),
            actions: noOpActions
        )

        XCTAssertEqual(items.compactMap(\.title), [
            "Kiki Starter: Trial active",
            "Open Settings...",
            "Open Paywall...",
            "Mock Pro",
            "Reset Mock State",
            "Quit Kiki Starter"
        ])
        XCTAssertEqual(menuItem(titled: "Kiki Starter: Trial active", in: items)?.isEnabled, false)
        XCTAssertEqual(menuItem(titled: "Open Paywall...", in: items)?.isEnabled, true)
        XCTAssertEqual(menuItem(titled: "Reset Mock State", in: items)?.isEnabled, false)
    }

    func testMenuModelForProUser() {
        let items = StarterMenuModel.items(
            config: .default,
            entitlement: StarterEntitlementSnapshot(isPro: true, isTrialActive: false),
            actions: noOpActions
        )

        XCTAssertNotNil(menuItem(titled: "Paywall unlocked", in: items))
        XCTAssertEqual(menuItem(titled: "Paywall unlocked", in: items)?.isEnabled, false)
        XCTAssertEqual(menuItem(titled: "Reset Mock State", in: items)?.isEnabled, true)
    }

    func testMenuModelForFreeAppTemplate() {
        let items = StarterMenuModel.items(
            config: StarterAppConfig.default.withPaidAccess(false),
            entitlement: StarterEntitlementSnapshot(isPro: false, isTrialActive: false),
            actions: noOpActions
        )

        XCTAssertEqual(items.compactMap(\.title), [
            "Open Settings...",
            "Quit Kiki Starter"
        ])
        XCTAssertNil(menuItem(titled: "Open Paywall...", in: items))
        XCTAssertNil(menuItem(titled: "Mock Pro", in: items))
    }

    func testMockEntitlementTransitions() {
        let store = MockEntitlementStore()

        XCTAssertFalse(store.isPro)
        XCTAssertTrue(store.isTrialActive)

        store.purchase(planID: "lifetime")
        XCTAssertTrue(store.isPro)
        XCTAssertFalse(store.isTrialActive)
        XCTAssertEqual(store.purchasedPlanID, "lifetime")

        store.reset()
        XCTAssertFalse(store.isPro)
        XCTAssertTrue(store.isTrialActive)
        XCTAssertNil(store.purchasedPlanID)
    }

    func testPlanConfigMapsToKikiPlan() {
        let plan = StarterAppConfig.default.plans[1].kikiPaywallPlan

        XCTAssertEqual(plan.id, "lifetime")
        XCTAssertEqual(plan.title, "Lifetime")
        XCTAssertEqual(plan.displayPrice, "$24.99")
        XCTAssertEqual(plan.badge, "Best value")
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
            openPaywall: {},
            toggleMockPro: {},
            resetMockState: {},
            quit: {}
        )
    }

    private func menuItem(titled title: String, in items: [KikiMenuItem]) -> KikiMenuItem? {
        items.first { $0.title == title }
    }

    private func isolatedDefaults() -> UserDefaults {
        let suiteName = "dev.kkuk.kikistarter.tests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
