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

            if config.includesPaidAccess {
                Section {
                    KikiSettingsStatusRow(
                        title: "Status",
                        value: entitlementStore.snapshot.accountStatus,
                        systemImage: "heart.circle",
                        valueColor: entitlementStore.isPro ? .accentColor : .secondary
                    )
                }
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

            #if DEBUG
            if config.includesPaidAccess {
                debugSection
            }
            #endif
        }
    }

    #if DEBUG
    private var debugSection: some View {
        Section("Developer Testing") {
            KikiSettingsStatusRow(
                title: "Test override",
                value: hasDebugAccessOverride ? "On" : "Off",
                systemImage: "hammer"
            )
            KikiSettingsToggleRow(
                "Paid access",
                isOn: Binding(
                    get: { entitlementStore.isPro },
                    set: { entitlementStore.setMockPro($0) }
                ),
                systemImage: "sparkles"
            )

            Button("Clear Test Override") {
                entitlementStore.reset()
            }
            .disabled(!hasDebugAccessOverride)

            KikiSettingsHelperText("Debug builds only. Forces the local paid gate without making or restoring a real purchase.")
        }
    }

    private var hasDebugAccessOverride: Bool {
        entitlementStore.isPro || !entitlementStore.isTrialActive
    }
    #endif

    private var versionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }
}
