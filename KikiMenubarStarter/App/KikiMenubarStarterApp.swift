import AppKit
import KikiMenuBar
import KikiSettings
import SwiftUI

@main
struct KikiMenubarStarterApp: App {
    @NSApplicationDelegateAdaptor(StarterAppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            StarterSettingsView(config: appDelegate.config)
        }
    }
}

@MainActor
final class StarterAppDelegate: NSObject, NSApplicationDelegate {
    let config = StarterAppConfig.default
    let onboardingState = StarterOnboardingState()

    private let settingsWindowController = KikiSettingsWindowController(
        frameAutosaveName: "KikiMenubarStarter.SettingsWindow",
        minimumContentSize: CGSize(
            width: KikiSettingsDefaults.minimumWindowWidth,
            height: KikiSettingsDefaults.minimumWindowHeight
        ),
        windowTitle: "Settings"
    )
    private lazy var settingsOpener = KikiSettingsOpener(windowController: settingsWindowController)
    private lazy var welcomeWindowController = StarterWelcomeWindowController(
        config: config,
        onboardingState: onboardingState,
        openSettings: { [weak self] in
            self?.openSettings()
        }
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
        welcomeWindowController.showIfNeeded()
    }

    private func menuItems() -> [KikiMenuItem] {
        StarterMenuModel.items(
            config: config,
            actions: StarterMenuActions(
                openSettings: { [weak self] in self?.openSettings() },
                quit: { NSApp.terminate(nil) }
            )
        )
    }

    private func openSettings() {
        settingsOpener.openForMenuBarApp()
    }
}
