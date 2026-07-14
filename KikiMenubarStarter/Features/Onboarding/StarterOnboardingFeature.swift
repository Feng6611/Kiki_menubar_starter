import KikiOnboarding
import SwiftUI

enum StarterOnboardingFeature {
    @MainActor
    static func makeCoordinator(
        definition: StarterAppDefinition,
        completionStore: KikiOnboardingCompletionStore,
        onOpenSettings: @escaping @MainActor () -> Void
    ) -> KikiOnboardingCoordinator {
        KikiOnboardingCoordinator(
            configuration: KikiOnboardingConfiguration(
                appName: definition.appName,
                steps: [welcomeStep(definition: definition, onOpenSettings: onOpenSettings)],
                completionKey: definition.onboardingCompletionKey,
                windowAutosaveName: definition.onboardingWindowAutosaveName,
                closeDisposition: .complete
            ),
            completionStore: completionStore
        )
    }

    @MainActor
    private static func welcomeStep(
        definition: StarterAppDefinition,
        onOpenSettings: @escaping @MainActor () -> Void
    ) -> KikiOnboardingStep {
        .custom(id: "starter-welcome") { navigation in
            AnyView(
                KikiOnboardingScaffold(
                    appName: definition.appName,
                    title: definition.onboardingTitle,
                    bodyText: definition.onboardingBody,
                    iconSystemName: "bolt.circle.fill",
                    rows: definition.onboardingItems.map {
                        KikiOnboardingRow(
                            systemImage: $0.systemImage,
                            title: $0.title,
                            detail: $0.detail
                        )
                    },
                    primaryAction: KikiOnboardingAction(
                        title: "Done",
                        action: navigation.finish
                    ),
                    secondaryAction: KikiOnboardingAction(
                        title: "Open Settings",
                        action: {
                            navigation.finish()
                            onOpenSettings()
                        }
                    )
                )
            )
        }
    }
}
