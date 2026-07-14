import SwiftUI

struct StarterWelcomeView: View {
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
                    Text("Start with the menu bar")
                        .font(.system(size: 30, weight: .bold, design: .rounded))

                    Text("\(config.appName) keeps its primary action in the menu bar and its controls in native Settings.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .frame(maxWidth: 430)
                }

                VStack(alignment: .leading, spacing: 12) {
                    welcomeRow(
                        systemImage: "menubar.rectangle",
                        title: "Menu bar first",
                        value: "The app starts from a status item and stays out of the Dock."
                    )
                    welcomeRow(
                        systemImage: "gearshape",
                        title: "Settings are the control surface",
                        value: "Put behavior, startup, recovery, and About content there."
                    )
                    welcomeRow(
                        systemImage: "checkmark.seal",
                        title: "Keep the template small",
                        value: "Add product-specific permissions, services, or paid access only when the app needs them."
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
    }

    private func welcomeRow(systemImage: String, title: String, value: String) -> some View {
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
