import Foundation

@MainActor
final class MockEntitlementStore: ObservableObject {
    @Published private(set) var isPro: Bool
    @Published private(set) var isTrialActive: Bool
    @Published private(set) var purchasedPlanID: String?
    @Published private(set) var restoredAt: Date?

    init(isPro: Bool = false, isTrialActive: Bool = true, purchasedPlanID: String? = nil) {
        self.isPro = isPro
        self.isTrialActive = isTrialActive
        self.purchasedPlanID = purchasedPlanID
    }

    var snapshot: StarterEntitlementSnapshot {
        StarterEntitlementSnapshot(isPro: isPro, isTrialActive: isTrialActive)
    }

    func purchase(planID: String) {
        isPro = true
        isTrialActive = false
        purchasedPlanID = planID
    }

    func restore() {
        isPro = true
        isTrialActive = false
        restoredAt = Date()
    }

    func setMockPro(_ isEnabled: Bool) {
        isPro = isEnabled
        if isEnabled {
            isTrialActive = false
            purchasedPlanID = purchasedPlanID ?? "mock"
        } else {
            purchasedPlanID = nil
        }
    }

    func reset() {
        isPro = false
        isTrialActive = true
        purchasedPlanID = nil
        restoredAt = nil
    }
}
