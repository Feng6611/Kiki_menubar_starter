import AppKit
import KikiWindow
import SwiftUI

@MainActor
final class StarterOnboardingState {
    private enum Keys {
        static let hasCompletedOnboarding = "KikiMenubarStarter.Onboarding.hasCompleted"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var hasCompletedOnboarding: Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }

    var shouldShowOnboarding: Bool {
        !hasCompletedOnboarding
    }

    func complete() {
        defaults.set(true, forKey: Keys.hasCompletedOnboarding)
    }

    func resetForTesting() {
        defaults.removeObject(forKey: Keys.hasCompletedOnboarding)
    }
}

@MainActor
final class StarterOnboardingWindowController {
    private let config: StarterAppConfig
    private let onboardingState: StarterOnboardingState
    private let openSettings: () -> Void
    private var isCompletingIntentionally = false

    private lazy var windowController = KikiSingleWindowController(
        configuration: .utility(
            title: "Welcome",
            size: CGSize(width: 560, height: 500),
            minimumSize: CGSize(width: 520, height: 460),
            frameAutosaveName: "KikiMenubarStarter.OnboardingWindow"
        ),
        onClose: { [weak self] in
            self?.handleWindowClose()
        }
    ) { [weak self, config] in
        StarterOnboardingView(
            config: config,
            onOpenSettings: {
                self?.finish()
                self?.openSettings()
            },
            onFinish: {
                self?.finish()
            }
        )
    }

    init(
        config: StarterAppConfig,
        onboardingState: StarterOnboardingState,
        openSettings: @escaping () -> Void
    ) {
        self.config = config
        self.onboardingState = onboardingState
        self.openSettings = openSettings
    }

    func showIfNeeded() {
        guard onboardingState.shouldShowOnboarding else {
            return
        }

        windowController.show()
    }

    private func finish() {
        isCompletingIntentionally = true
        onboardingState.complete()
        windowController.close()
    }

    private func handleWindowClose() {
        guard !isCompletingIntentionally else {
            isCompletingIntentionally = false
            return
        }

        onboardingState.complete()
    }
}

struct StarterOnboardingView: View {
    let config: StarterAppConfig
    let onOpenSettings: () -> Void
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 26)

            VStack(spacing: 18) {
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 90, height: 90)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.accentColor.opacity(0.1))
                    )

                VStack(spacing: 8) {
                    Text(config.appName)
                        .font(.system(size: 30, weight: .bold, design: .rounded))

                    Text("A small menu bar app with native Settings, optional paid access, and app-owned product logic.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .frame(maxWidth: 430)
                }

                VStack(alignment: .leading, spacing: 12) {
                    onboardingRow(
                        systemImage: "menubar.rectangle",
                        title: "Menu bar first",
                        value: "The app starts from a status item and keeps Settings reachable."
                    )
                    onboardingRow(
                        systemImage: "gearshape",
                        title: "Settings are the control surface",
                        value: "Put behavior, permission, startup, and About content there."
                    )
                    onboardingRow(
                        systemImage: config.includesPaidAccess ? "creditcard" : "checkmark.seal",
                        title: config.includesPaidAccess ? "Paid access is optional" : "Free app shape",
                        value: config.includesPaidAccess
                            ? "Keep purchase state in the app and show the result in About."
                            : "Remove paywall, trial, Pro, product id, and purchase copy."
                    )
                }
                .frame(maxWidth: 430, alignment: .leading)
                .padding(.top, 8)
            }
            .padding(.horizontal, 40)

            Spacer(minLength: 24)

            HStack(spacing: 12) {
                Button("Open Settings") {
                    onOpenSettings()
                }
                .buttonStyle(.bordered)

                Spacer(minLength: 0)

                Button("Done") {
                    onFinish()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 34)
            .padding(.bottom, 28)
        }
        .frame(width: 560, height: 500)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private func onboardingRow(systemImage: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.accentColor)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.callout.weight(.semibold))
                Text(value)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
    }
}
