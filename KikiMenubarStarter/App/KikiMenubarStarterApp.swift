import AppKit
import KikiMenuBar
import KikiSettings
import SwiftUI

@main
struct KikiMenubarStarterApp: App {
    @NSApplicationDelegateAdaptor(StarterAppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            StarterSettingsView(
                config: appDelegate.config,
                entitlementStore: appDelegate.entitlementStore
            )
        }
    }
}

@MainActor
final class StarterAppDelegate: NSObject, NSApplicationDelegate {
    let config = StarterAppConfig.default
    let entitlementStore = MockEntitlementStore()

    private let settingsWindowController = KikiSettingsWindowController(
        frameAutosaveName: "KikiMenubarStarter.SettingsWindow",
        minimumContentSize: CGSize(
            width: KikiSettingsDefaults.minimumWindowWidth,
            height: KikiSettingsDefaults.minimumWindowHeight
        ),
        windowTitle: "Settings"
    )
    private lazy var settingsOpener = KikiSettingsOpener(windowController: settingsWindowController)
    private lazy var paywallWindowController = StarterPaywallWindowController(
        config: config,
        entitlementStore: entitlementStore
    )
    private var menuBarController: KikiMenuBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        menuBarController = KikiMenuBarController(
            title: config.statusItemTitle,
            autosaveName: "KikiMenubarStarter.StatusItem",
            systemImageName: "bolt.circle",
            accessibilityDescription: config.appName,
            tooltip: config.appName,
            itemsProvider: { [weak self] in
                self?.menuItems() ?? []
            }
        )
    }

    private func menuItems() -> [KikiMenuItem] {
        StarterMenuModel.items(
            config: config,
            entitlement: entitlementStore.snapshot,
            actions: StarterMenuActions(
                openSettings: { [weak self] in self?.openSettings() },
                openPaywall: { [weak self] in self?.openPaywall() },
                toggleMockPro: { [weak self] in self?.toggleMockPro() },
                resetMockState: { [weak self] in self?.entitlementStore.reset() },
                quit: { NSApp.terminate(nil) }
            )
        )
    }

    private func openSettings() {
        settingsOpener.open()
    }

    private func openPaywall() {
        paywallWindowController.show()
    }

    private func toggleMockPro() {
        entitlementStore.setMockPro(!entitlementStore.isPro)
    }
}
