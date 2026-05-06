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
}

struct StarterSettingsView: View {
    let config: StarterAppConfig
    @ObservedObject var entitlementStore: MockEntitlementStore
    @StateObject private var navigation = KikiSettingsNavigationModel<StarterSettingsTab>(selectedTab: .general)

    var body: some View {
        TabView(selection: $navigation.selectedTab) {
            generalPane
                .tabItem { Label(StarterSettingsTab.general.title, systemImage: StarterSettingsTab.general.systemImage) }
                .tag(StarterSettingsTab.general)

            accountPane
                .tabItem { Label(StarterSettingsTab.account.title, systemImage: StarterSettingsTab.account.systemImage) }
                .tag(StarterSettingsTab.account)

            aboutPane
                .tabItem { Label(StarterSettingsTab.about.title, systemImage: StarterSettingsTab.about.systemImage) }
                .tag(StarterSettingsTab.about)
        }
        .padding(20)
        .frame(width: 520, height: 360)
    }

    private var generalPane: some View {
        KikiSettingsUI.FormPane {
            Section("Startup") {
                LaunchAtLogin.Toggle("Launch at Login")
            }

            Section("Status") {
                LabeledContent("Menu bar title", value: config.statusItemTitle)
                LabeledContent("Entitlement", value: entitlementStore.snapshot.accountStatus)
            }
        }
    }

    private var accountPane: some View {
        KikiSettingsUI.FormPane {
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
        VStack(spacing: 18) {
            KikiSettingsUI.AppIdentityView(
                appName: config.appName,
                versionText: "Starter 1.0"
            )

            KikiSettingsUI.FormPane {
                Section("Links") {
                    KikiSettingsUI.LinkButton(
                        title: "Kiki_mackit",
                        urlString: config.supportURL,
                        systemImage: "shippingbox"
                    )
                    KikiSettingsUI.LinkButton(
                        title: "Starter repository",
                        urlString: config.repositoryURL,
                        systemImage: "chevron.left.forwardslash.chevron.right"
                    )
                    KikiSettingsUI.CopyRow(
                        title: "Bundle ID",
                        value: "com.kiki.menubarstarter",
                        systemImage: "number"
                    )
                }
            }
        }
    }
}
