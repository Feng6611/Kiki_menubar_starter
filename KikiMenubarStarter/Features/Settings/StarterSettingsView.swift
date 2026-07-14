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
    let config: StarterAppConfig
    @StateObject private var navigation = KikiSettingsNavigationModel<StarterSettingsTab>(selectedTab: .general)

    var body: some View {
        KikiSettingsShell(
            selection: $navigation.selectedTab,
            tabs: StarterSettingsTab.kikiTabs
        ) { tab in
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
                    value: config.statusItemTitle,
                    systemImage: "menubar.rectangle"
                )
            }
        }
    }

    private var aboutPane: some View {
        KikiSettingsPane {
            Section {
                KikiAppIdentityView(
                    appName: config.appName,
                    versionText: versionText
                )
                .padding(.vertical, 20)
            }

            Section {
                KikiSettingsLinkRow(
                    title: "Official",
                    value: config.officialDisplayName,
                    urlString: config.officialURL,
                    systemImage: "globe"
                )
                KikiSettingsCopyRow(
                    title: "Email",
                    value: config.contactEmailAddress,
                    systemImage: "envelope"
                )
                KikiSettingsLinkRow(
                    title: "GitHub",
                    value: config.repositoryDisplayName,
                    urlString: config.repositoryURL,
                    systemImage: "chevron.left.forwardslash.chevron.right"
                )
            }
        }
    }

    private var versionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }
}
