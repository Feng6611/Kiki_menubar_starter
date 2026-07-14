# Settings Design Guide

This guide defines the default Settings shape for new Kiki-based Mac menu bar
apps.

The goal is not to expose every configurable value. The first Settings window
should help users understand and control the product without reading docs.

## First Version Rule

The first version of Settings should answer:

1. What is the app doing now?
2. What can I safely change?
3. What permission or access state affects the app?
4. How do I recover if the app blocks, hides, sends, or changes something?
5. Where can I confirm version, privacy, support, and source information?

If a setting does not help one of those questions, keep it out of the first
version.

Design the first version from the user's scan path, not from the code modules:

1. current product state;
2. controls that change the core behavior;
3. safety, permission, and recovery;
4. startup and background behavior;
5. identity, support, source, and Debug-only diagnostics.

This keeps Settings useful on day one without turning it into an inventory of
every stored preference.

## Recommended Tabs

Use two tabs for simple apps:

- `General`: primary behavior, startup, format defaults, and the most important
  status.
- `About`: app identity, privacy summary, version, support, and copyable
  diagnostics in Debug builds only.

Use three tabs only when the app has a real second domain:

- `General` or product-named tab: the core product controls.
- `System`: permissions, launch at login, system integration, and recovery.
- `About`: identity, privacy, plan, links, and diagnostics.

Use an access or account tab only when it contains real user account management.
For small paid utilities, the first version should usually show paid status in
`About` and open the paywall from the menu or a dedicated window, not from a
separate Settings tab. Mock or debug entitlement controls should not shape the
release Settings design.

Do not add a tab only because the implementation has a matching service,
manager, store, or package. A tab needs a user-facing domain.

## Section Order

Within the primary tab, prefer this order:

1. current status and primary action;
2. core behavior controls;
3. safety or recovery controls;
4. automation or startup behavior;
5. advanced tuning.

Within the system tab, prefer:

1. required permissions and fix actions;
2. launch at login;
3. integrations with macOS services;
4. reset or recovery actions.

## Copy Rules

- Use user language, not implementation language.
- Section names should be nouns: `Lock`, `Send Format`, `Permissions`,
  `Startup`, `Recovery`.
- Row labels should be short and concrete.
- Helper text should explain consequence, safety, or recovery, not restate the
  row label.
- Avoid exposing internal words such as mock, controller, store, entitlement, or
  framework in release UI.
- Use `Pro`, `Trial`, or `Plan` for user-facing access. Use entitlement only in
  code and debug UI.

## Component Rules

- Use `KikiSettingsShell` for tabbed Settings.
- Use `KikiSettingsPane` for each tab body.
- Use `KikiAppIdentityView` for custom About pages that need extra sections
  below the normal app identity block.
- Use `KikiSettingsStatusRow` for read-only state.
- Use `KikiSettingsToggleRow` for binary behavior.
- Use `KikiSettingsSegmentedPickerRow` for two to five short choices.
- Use `KikiSettingsSliderRow` for continuous tuning where users need live
  adjustment and a visible value.
- Use `KikiSettingsLinkRow` for support, source, and policy links.
- Use `KikiSettingsCopyRow` for bundle id, diagnostics, and identifiers.
- Use `KikiSettingsHelperText` for section footers that explain risk,
  permission need, or recovery.

Prefer Kiki row components over raw SwiftUI controls so alignment, icons,
labels, and values stay consistent across products.

## Minimum About Tab

Every app should include:

- icon, app name, and version text in the form `Version 1.2.3 (45)`;
- `Status` only when the app has paid, trial, account, or license state;
- `Official`, `Email`, and `GitHub` rows when those links exist;
- GitHub row value as the repository display name, such as
  `Feng6611/mac-airdrop-clipboard`;
- Debug-only diagnostics or local test controls below the normal About content.

Do not show package names or the app bundle identifier in release About. Use
bundle id only in Debug diagnostics or when a support workflow explicitly needs
it.

Platform-risk apps should also show the most important permission or privacy
state when it helps the user understand safety, for example `Privacy: Local
only` or `Accessibility: Allowed`.

Canonical About order:

1. identity block: icon, app name, `Version x.x.x (build)`;
2. optional user-facing `Status` row for paid/trial/license/account state;
3. optional safety or privacy summary if it materially helps the user;
4. links: `Official`, `Email`, `GitHub`;
5. Debug-only diagnostics and local test controls.

The About page should not mention `Kiki_mackit`, `RevenueCatCommerceKit`, SwiftPM
package names, bundle id, product ids, or entitlement ids in Release builds.
Those are engineering diagnostics, not user-facing About content.

For paid apps, do not repeat Pro, trial, purchase, or mock entitlement controls
in other Settings panes. The menu, onboarding, or paywall window can route the
purchase flow; Settings should show the resulting user-facing access state in
About.

## About Implementation Rule

Kiki owns the reusable About building blocks: `KikiAppIdentityView`,
`KikiAboutPane`, and the standard settings rows. The product app owns the actual
content: official site, support email, repository, paid status, privacy summary,
and debug controls.

For a simple release About page, `KikiAboutPane` is enough. When the app needs a
Debug-only diagnostics section, compose the page with `KikiSettingsPane`,
`KikiAppIdentityView`, and Kiki rows so the diagnostics can sit below the normal
About content.

Recommended helpers:

```swift
private var versionText: String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    return "Version \(version) (\(build))"
}
```

```swift
Section {
    KikiSettingsLinkRow(
        title: "Official",
        value: "example.com",
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
```

Debug test controls should sit under About and be wrapped in `#if DEBUG`. Use
plain user-facing labels such as `Test override`, `Paid access`, and
`Clear Test Override`. Do not use Debug controls to justify adding a release
`Account`, `Plan`, or `Access` tab.

## Paid and Free App Shape

Free apps should remove paywall UI, purchase stores, product ids, and
`KikiCommerceKit`. They should not show `Status`, `Plan`, `Pro`, trial, or
mock purchase controls unless the product really has that concept.

Paid apps should keep commerce state app-owned. The app may use
`KikiCommerceKit` for purchase transport and `KikiPaywall` for display,
but Kiki should not know product ids, entitlement ids, prices, trial rules, or
RevenueCat configuration. In Settings, show the resulting user-facing access
state in `About` as `Status`; do not repeat Pro or purchase controls in other
settings panes.

The starter default is always free: it has no Paywall menu item, About `Status`,
or Debug paid-access controls. A paid product should add `KikiCommerceKit` and
app-owned access state after copying the template, rather than turning the
starter into a mock-commerce app.

## Release Checklist

Before shipping the first Settings window:

- the first tab shows the app's current state or primary behavior;
- platform permissions have a visible status and fix action;
- paid access does not disable recovery controls;
- debug-only controls are hidden from release builds;
- paid status appears in About only, unless the app has a real account surface;
- every segmented picker has labels that make sense without docs;
- helper text explains consequences in one sentence;
- About has no empty sections;
- release About does not show package names or bundle id;
- all visible copy avoids internal implementation terms;
- Settings can be opened from the menu bar app even when the main feature is in
  a failed, disabled, locked, or permission-missing state.
