# Kiki Menubar Starter

A minimal macOS menu bar app starter built on [Kiki_mackit](https://github.com/Feng6611/Kiki_mackit). It shows how to connect a status item, settings window, launch-at-login control, mock entitlement state, and paywall UI without bringing in a real purchase backend.

## Feature List

- Menu bar app shell with `KikiMenuBarController`.
- Reusable settings window with `KikiSettingsWindowController` and `KikiSettingsOpener`.
- Launch at Login setting exposed through `KikiSettings`.
- Mock entitlement store for free, trial, and pro states.
- Paywall content composed from `KikiPaywall` UI atoms and presented through Kiki's window presenter.
- Central app config for labels, links, plan copy, and feature copy.
- Unit tests for menu mapping, entitlement transitions, and plan mapping.

## Technical Choices

- Xcode macOS SwiftUI app: easiest path for a real starter that opens in Xcode and builds like a normal app.
- AppKit shell at platform edges: `NSStatusItem` behavior belongs in AppKit, and standalone utility windows use Kiki's AppKit presenter with SwiftUI content.
- `Kiki_mackit` 0.3.0 dependency: UI packages only, with commerce split out.
- `RevenueCatCommerceKit` 0.1.0 dependency: purchase transport is available from the standalone commerce package instead of from `Kiki_mackit`.
- Mock entitlement instead of RevenueCat: the starter stays usable without API keys, products, or App Store setup.
- Small config-first surface: most project-specific changes should happen in `StarterAppConfig`.

## Architecture

The starter uses an app-target structure that can grow into a larger product
without immediately creating extra packages:

- `App/`: app lifecycle, AppKit glue, and Kiki wiring.
- `Features/`: settings, menu bar, paywall UI, display config, and Kiki adapters.
- `Platform/`: optional wrappers for direct macOS services when a product needs them.
- `Shared/`: app-local configuration, copy, links, and future defaults.
- `Core/`: optional pure rules only when there is a real platform-free boundary.

See [Docs/Architecture.md](Docs/Architecture.md) for the boundary rules and the
path toward optional `Platform/` or `Core/` layers when the app actually needs them.

## Run

```sh
xcodebuild -project KikiMenubarStarter.xcodeproj -scheme KikiMenubarStarter -configuration Debug -destination 'platform=macOS' build
```

Open `KikiMenubarStarter.xcodeproj` in Xcode and run the `KikiMenubarStarter` scheme. The app is an accessory menu bar app, so it does not show a Dock icon.

## Replace Mock Purchases

- Keep `StarterPaywallView` as the UI shell.
- Replace `MockEntitlementStore` with your real store.
- Use the app target's standalone `RevenueCatCommerceKit` dependency.
- Map real products into `StarterPlanConfig` or into `KikiPaywallPlan`.
- Move API keys, entitlement ids, and product ids into your app-specific config, not into Kiki packages.

## Onboarding Paywall Close Semantics

If you add onboarding before the paywall, audit the flow-out paths before
shipping. A common failure mode is to gate launch on `hasSeenOnboarding == false`
while only setting that flag after purchase or trial start. Users who close the
paywall, quit the app mid-flow, restore later, or already have entitlement can
then see onboarding on every launch.

Keep the completion state in app code:

- Do not mark onboarding complete just because the window was shown.
- Mark onboarding complete when the user finishes the flow: starts a trial,
  completes purchase, restores entitlement, or closes the paywall from the
  onboarding context.
- Treat the onboarding paywall close button like a skip action. It should call
  the same app-owned completion method as other onboarding exits, then route to
  the next host surface such as Settings.
- Decide intentionally what happens for app quit/relaunch, already-entitled
  accounts, restore errors, purchase cancellation, and explicit close. Each path
  should either complete onboarding or leave it pending by design.
- Keep this routing outside `KikiPaywall`; the Kiki package provides reusable UI
  atoms, while the starter/app owns persistence and follow-up windows.

## Upgrade Kiki

- Update the `Kiki_mackit` Swift package requirement in Xcode.
- Re-run the build and unit tests.
- Keep app-specific business logic in the starter/app; only reusable UI and mechanics should move into Kiki.

## Todo / Checklist

- [ ] Replace placeholder links in `StarterAppConfig`.
- [ ] Add a real app icon and bundle identifier.
- [ ] Decide whether to keep `LSUIElement` for a pure menu bar app.
- [ ] Replace mock entitlement with real purchase logic when needed.
- [ ] Add onboarding only if the product needs first-launch education.
