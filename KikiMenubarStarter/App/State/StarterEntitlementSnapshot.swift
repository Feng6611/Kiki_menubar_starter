import Foundation

struct StarterEntitlementSnapshot: Equatable {
    let isPro: Bool
    let isTrialActive: Bool

    var accountStatus: String {
        if isPro {
            return "Pro active"
        }

        if isTrialActive {
            return "Trial active"
        }

        return "Free"
    }
}
