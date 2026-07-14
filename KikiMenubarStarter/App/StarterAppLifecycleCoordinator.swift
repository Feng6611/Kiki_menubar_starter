import AppKit
import KikiMenuBar

@MainActor
final class StarterAppLifecycleCoordinator {
    private let definition: StarterAppDefinition
    private let router: StarterAppRouter
    private var menuBarController: KikiMenuBarController?
    private var didStart = false

    init(
        definition: StarterAppDefinition,
        router: StarterAppRouter
    ) {
        self.definition = definition
        self.router = router
    }

    func start() {
        guard didStart == false else {
            return
        }
        didStart = true

        NSApp.setActivationPolicy(.accessory)
        menuBarController = KikiMenuBarController(
            title: definition.statusItemTitle,
            autosaveName: definition.statusItemAutosaveName,
            systemImageName: "bolt.circle",
            accessibilityDescription: definition.appName,
            tooltip: definition.appName,
            itemsProvider: { [weak self] in
                self?.menuItems() ?? []
            }
        )
        router.showOnboardingIfNeeded()
    }

    func stop() {
        menuBarController = nil
    }

    private func menuItems() -> [KikiMenuItem] {
        StarterMenuModel.items(
            definition: definition,
            actions: StarterMenuActions(
                openSettings: { [weak self] in self?.router.openSettings() },
                quit: { [weak self] in self?.router.quit() }
            )
        )
    }
}
