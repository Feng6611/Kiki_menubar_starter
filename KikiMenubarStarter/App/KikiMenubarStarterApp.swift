import SwiftUI

@main
struct KikiMenubarStarterApp: App {
    @NSApplicationDelegateAdaptor(StarterAppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            StarterSettingsView(
                definition: appDelegate.composition.definition,
                coordinator: appDelegate.composition.settingsCoordinator
            )
        }
    }
}

@MainActor
final class StarterAppDelegate: NSObject, NSApplicationDelegate {
    let composition = StarterAppComposition()

    func applicationDidFinishLaunching(_ notification: Notification) {
        composition.lifecycle.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        composition.lifecycle.stop()
    }
}
