# Kiki Menubar Starter

A minimal macOS menu bar app starter built on [Kiki_mackit](https://github.com/Feng6611/Kiki_mackit). It shows how to connect a status item, settings window, launch-at-login control, mock entitlement state, and paywall UI without bringing in a real purchase backend.

## Feature List

- Menu bar app shell with `KikiMenuBarController`.
- Reusable settings window with `KikiSettingsWindowController` and `KikiSettingsOpener`.
- Launch at Login setting exposed through `KikiSettings`.
- Mock entitlement store for free, trial, and pro states.
- Paywall window composed from `KikiPaywall` UI atoms.
- Central app config for labels, links, plan copy, and feature copy.
- Unit tests for menu mapping, entitlement transitions, and plan mapping.

## Technical Choices

- Xcode macOS SwiftUI app: easiest path for a real starter that opens directly in Xcode and builds like a normal app.
- AppKit menu bar controller: `NSStatusItem` behavior belongs in AppKit, while SwiftUI owns windows and reusable panes.
- `Kiki_mackit` exact tag dependency: the starter remains stable and cloneable; upgrade deliberately when Kiki changes.
- Mock entitlement instead of RevenueCat: the starter stays usable without API keys, products, or App Store setup.
- Small config-first surface: most project-specific changes should happen in `StarterAppConfig`.

## Run

```sh
xcodebuild -project KikiMenubarStarter.xcodeproj -scheme KikiMenubarStarter -configuration Debug -destination 'platform=macOS' build
```

Open `KikiMenubarStarter.xcodeproj` in Xcode and run the `KikiMenubarStarter` scheme. The app is an accessory menu bar app, so it does not show a Dock icon.

## Replace Mock Purchases

- Keep `StarterPaywallView` as the UI shell.
- Replace `MockEntitlementStore` with your real store.
- Add `RevenueCatCommerceKit` from `Kiki_mackit` to the app target.
- Map real products into `StarterPlanConfig` or directly into `KikiPaywallPlan`.
- Move API keys, entitlement ids, and product ids into your app-specific config, not into Kiki packages.

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
