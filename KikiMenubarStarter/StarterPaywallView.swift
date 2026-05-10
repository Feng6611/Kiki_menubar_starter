import AppKit
import KikiPaywall
import SwiftUI

@MainActor
final class StarterPaywallWindowController {
    private let config: StarterAppConfig
    private let entitlementStore: MockEntitlementStore
    private var window: NSWindow?

    init(config: StarterAppConfig, entitlementStore: MockEntitlementStore) {
        self.config = config
        self.entitlementStore = entitlementStore
    }

    func show() {
        if let window {
            window.makeKeyAndOrderFront(nil)
            activateApp()
            return
        }

        let rootView = StarterPaywallView(config: config, entitlementStore: entitlementStore)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 620),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Upgrade"
        window.contentView = NSHostingView(rootView: rootView)
        window.center()
        window.isReleasedWhenClosed = false
        self.window = window
        window.makeKeyAndOrderFront(nil)
        activateApp()
    }

    private func activateApp() {
        NSRunningApplication.current.activate(options: [.activateIgnoringOtherApps])
        NSApp.activate(ignoringOtherApps: true)
    }
}

struct StarterPaywallView: View {
    let config: StarterAppConfig
    @ObservedObject var entitlementStore: MockEntitlementStore

    @State private var selectedPlanID: String
    @State private var isPurchasing = false

    init(config: StarterAppConfig, entitlementStore: MockEntitlementStore) {
        self.config = config
        self.entitlementStore = entitlementStore
        self._selectedPlanID = State(initialValue: config.plans.first?.id ?? "")
    }

    var body: some View {
        KikiPaywallShell(
            width: 520,
            height: 620,
            horizontalPadding: 28
        ) {
            KikiPaywallHeader(
                title: config.appName,
                subtitle: entitlementStore.isPro ? "Pro is active" : "Unlock the reusable menu bar app flow"
            )
        } content: {
            HStack(spacing: 12) {
                ForEach(config.stats, id: \.label) { stat in
                    KikiPaywallStatItem(value: stat.value, label: stat.label)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(config.features, id: \.self) { feature in
                    KikiPaywallFeatureRow(icon: "checkmark.circle", text: feature)
                }
            }

            HStack(spacing: 12) {
                ForEach(config.plans) { plan in
                    KikiPaywallPlanCard(
                        plan: plan.kikiPaywallPlan,
                        isSelected: selectedPlanID == plan.id,
                        onSelect: { selectedPlanID = plan.id }
                    )
                }
            }
        } actions: {
            Button {
                purchaseSelectedPlan()
            } label: {
                KikiPaywallActionLabel(
                    title: entitlementStore.isPro ? "Already Pro" : "Mock Purchase",
                    isLoading: isPurchasing,
                    isProminent: true
                )
            }
            .buttonStyle(.plain)
            .disabled(entitlementStore.isPro || isPurchasing || selectedPlanID.isEmpty)

            Button {
                entitlementStore.restore()
            } label: {
                KikiPaywallActionLabel(
                    title: "Restore Mock Purchase",
                    isLoading: false,
                    isProminent: false
                )
            }
            .buttonStyle(.plain)
            .disabled(entitlementStore.isPro)
        } footer: {
            EmptyView()
        }
    }

    private func purchaseSelectedPlan() {
        guard !selectedPlanID.isEmpty else {
            return
        }

        isPurchasing = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 250_000_000)
            entitlementStore.purchase(planID: selectedPlanID)
            isPurchasing = false
        }
    }
}
