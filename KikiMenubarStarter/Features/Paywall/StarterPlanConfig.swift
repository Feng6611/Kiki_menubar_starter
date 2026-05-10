import Foundation

struct StarterPlanConfig: Equatable, Identifiable {
    let id: String
    let title: String
    let displayPrice: String
    let originalPrice: String?
    let billingDetail: String
    let badge: String?
}
