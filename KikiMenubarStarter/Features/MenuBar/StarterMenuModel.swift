import AppKit
import KikiMenuBar

@MainActor
struct StarterMenuActions {
    let openSettings: () -> Void
    let quit: () -> Void
}

enum StarterMenuModel {
    @MainActor
    static func items(
        config: StarterAppConfig,
        actions: StarterMenuActions
    ) -> [KikiMenuItem] {
        [
            .settings(
                title: "Open Settings...",
                action: actions.openSettings
            ),
            .separator,
            .quit(
                appName: config.appName,
                action: actions.quit
            )
        ]
    }
}
