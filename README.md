# Kiki Menubar Starter

A small, free macOS menu bar app template built on
[Kiki_mackit](https://github.com/Feng6611/Kiki_mackit). It demonstrates the
minimum product shell: a status item, a native Settings window, an About page,
and a recoverable first-launch welcome window.

## Default shape

- `KikiMenuBarController` for the menu bar shell.
- `AppDefinition`, `AppComposition`, `AppRouter`, and
  `AppLifecycleCoordinator` as the stable Product App skeleton.
- `KikiSettingsCoordinatorView` and `KikiStandardAboutPane` for Settings.
- `KikiOnboardingCoordinator` for the first-launch window, navigation, and
  completion-store mechanism.
- Launch-at-login, official site, email, GitHub, version, and app identity
  examples.
- Unit tests for menu routing and composition-owned Feature coordinators.

The default target is intentionally free. It does not link RevenueCat,
`KikiCommerceKit`, `KikiPaywall`, Pro/Trial/Plan state, product identifiers, or
mock purchase controls.

## Architecture

The starter keeps the app target small and explicit:

- `App/`: Definition, Composition, Router, Lifecycle, app entry point, and thin
  AppDelegate.
- `Features/`: app-owned menu declarations, Settings panes, and Onboarding
  content/actions on top of Kiki Features.
- no `Core/`, `Platform/`, or `Shared/` layer until real code needs one.

See [Docs/Architecture.md](Docs/Architecture.md) for the boundary rules.

## First-launch flow

The welcome window is app-owned and recoverable. Closing it marks onboarding
complete, while `Open Settings` completes onboarding before opening the real
Settings surface. Products that need Accessibility or another permission should
add that setup explicitly with `KikiAuthorization`; the starter does not invent
a permission gate.

See [Docs/OnboardingDesignGuide.md](Docs/OnboardingDesignGuide.md) before adding
product-specific setup.

## Turning a copy into a paid app

Paid access is an opt-in product expansion, not part of this template. A paid
product should add [KikiCommerceKit](https://github.com/Feng6611/KikiCommerceKit)
as a separate dependency, keep purchase state in the product app, and use
Kiki's paywall presentation only after the product has real plans and access
rules. Do not reintroduce a mock store or a second paywall implementation into
the free starter target.

## Run and test

```sh
./script/build_and_run.sh --verify
xcodebuild test -project KikiMenubarStarter.xcodeproj \
  -scheme KikiMenubarStarter \
  -destination 'platform=macOS,arch=arm64'
```

The app is an accessory menu bar app, so it does not show a Dock icon.

## Release checklist

Before shipping a product copied from this template, configure the product's
bundle identifier, icon, privacy/support links, App Sandbox, signing,
notarization, and any product-specific permissions or commerce dependencies.
Update the Feature Inventory and journey cases when adding a new surface.
