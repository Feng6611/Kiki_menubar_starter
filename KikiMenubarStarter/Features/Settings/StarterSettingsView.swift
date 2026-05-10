import KikiSettings
import SwiftUI

enum StarterSettingsTab: String, CaseIterable, Identifiable {
    case general
    case account
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general:
            return "General"
        case .account:
            return "Account"
        case .about:
            return "About"
        }
    }

    var systemImage: String {
        switch self {
        case .general:
            return "gearshape"
        case .account:
            return "person.crop.circle"
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
    @ObservedObject var entitlementStore: MockEntitlementStore
    @StateObject private var navigation = KikiSettingsNavigationModel<StarterSettingsTab>(selectedTab: .general)

    var body: some View {
        KikiSettingsShell(
            selection: $navigation.selectedTab,
            tabs: StarterSettingsTab.kikiTabs
        ) { tab in
            switch tab {
            case .general:
                generalPane
            case .account:
                accountPane
            case .about:
                aboutPane
            }
        }
    }

    private var generalPane: some View {
        KikiSettingsPane {
            Section("Startup") {
                LaunchAtLogin.Toggle("Launch at Login")
            }

            Section("Status") {
                KikiSettingsStatusRow(
                    title: "Menu bar title",
                    value: config.statusItemTitle,
                    systemImage: "menubar.rectangle"
                )
                KikiSettingsStatusRow(
                    title: "Entitlement",
                    value: entitlementStore.snapshot.accountStatus,
                    systemImage: "person.crop.circle"
                )
            }
        }
    }

    private var accountPane: some View {
        KikiSettingsPane {
            Section("Mock Entitlement") {
                Toggle("Pro enabled", isOn: Binding(
                    get: { entitlementStore.isPro },
                    set: { entitlementStore.setMockPro($0) }
                ))

                Button("Restore Mock Purchase") {
                    entitlementStore.restore()
                }

                Button("Reset Mock State") {
                    entitlementStore.reset()
                }
            }
        }
    }

    private var aboutPane: some View {
        KikiAboutPane(
            appName: config.appName,
            versionText: "Starter 1.0"
        ) {
            KikiSettingsStatusRow(
                title: "Status",
                value: entitlementStore.snapshot.accountStatus,
                systemImage: "heart.circle"
            )
        } links: {
            KikiSettingsLinkRow(
                title: "Kiki_mackit",
                value: "Package",
                urlString: config.supportURL,
                systemImage: "shippingbox"
            )
            KikiSettingsLinkRow(
                title: "Starter repository",
                value: "GitHub",
                urlString: config.repositoryURL,
                systemImage: "chevron.left.forwardslash.chevron.right"
            )
            KikiSettingsCopyRow(
                title: "Bundle ID",
                value: "com.kiki.menubarstarter",
                systemImage: "number"
            )
        }
    }
}
