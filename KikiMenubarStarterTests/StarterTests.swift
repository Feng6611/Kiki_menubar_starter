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
        XCTAssertFalse(items[0].isEnabled)
        XCTAssertTrue(items[3].isEnabled)
        XCTAssertFalse(items[5].isEnabled)
    }

    func testMenuModelForProUser() {
        let items = StarterMenuModel.items(
            config: .default,
            entitlement: StarterEntitlementSnapshot(isPro: true, isTrialActive: false),
            actions: noOpActions
        )

        XCTAssertEqual(items.compactMap(\.title)[2], "Paywall unlocked")
        XCTAssertFalse(items[3].isEnabled)
        XCTAssertTrue(items[5].isEnabled)
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

    private var noOpActions: StarterMenuActions {
        StarterMenuActions(
            openSettings: {},
            openPaywall: {},
            toggleMockPro: {},
            resetMockState: {},
            quit: {}
        )
    }
}
