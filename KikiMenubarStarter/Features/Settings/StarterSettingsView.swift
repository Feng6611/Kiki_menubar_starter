import KikiSettings
import SwiftUI

enum StarterSettingsTab: String, CaseIterable, Identifiable {
    case general
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general:
            return "General"
        case .about:
            return "About"
        }
    }

    var systemImage: String {
        switch self {
        case .general:
            return "gearshape"
        case .about:
            return "info.circle"
        }
    }

    static var kikiTabs: [KikiSettingsTabSpec<StarterSettingsTab>] {
        allCases.map { tab in
            KikiSettingsTabSpec(tab, title: tab.title, systemImage: tab.systemImage)
        }
    }
}

struct StarterSettingsView: View {
    let definition: StarterAppDefinition
    let coordinator: KikiSettingsCoordinator<StarterSettingsTab>

    var body: some View {
        KikiSettingsCoordinatorView(coordinator: coordinator) { tab in
            switch tab {
            case .general:
                generalPane
            case .about:
                aboutPane
            }
        }
    }

    private var generalPane: some View {
        KikiSettingsPane {
            Section("Startup") {
                KikiSettings.LaunchAtLogin.Toggle("Launch at Login")
            }

            Section("Menu Bar") {
                KikiSettingsStatusRow(
                    title: "Menu bar item",
                    value: definition.statusItemTitle,
                    systemImage: "menubar.rectangle"
                )
            }
        }
    }

    private var aboutPane: some View {
        KikiStandardAboutPane(
            metadata: .bundle(),
            links: KikiStandardAboutLinks(
                website: definition.officialURL,
                feedback: definition.feedbackURL,
                github: definition.repositoryURL
            )
        )
    }
}
