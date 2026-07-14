# Architecture

This starter is a small menu bar app template. Its structure follows the
practical shape used by Command Reopen: keep the app shell thin, group product
surfaces by feature, isolate system services only when they appear, and avoid a
heavy `Core/` layer until there is a real second consumer.

## Design Standard

Start from the smallest app-target shape that makes ownership obvious:

- Visible UI: prefer SwiftUI.
- System integration: isolate AppKit or CoreGraphics at the edge.
- Complex window or menu behavior: use an AppKit container with SwiftUI content.
- Product rules: keep them in the app target unless they are pure and need a
  second consumer.

Direct, Mac App Store, and other distribution modes are build and release
concerns. They should not be the primary source-code architecture split.

Create a folder only when there is code that clearly belongs there. Empty
architecture folders make a small app harder to read.

## Default Boundaries

### App

`App/` owns the application shell:

- SwiftUI `App` entry point.
- `NSApplicationDelegate` and activation policy.
- Kiki package wiring for menu bar, settings, and window presentation.
- App-owned state stores and coordinators that connect user actions to features.

App code may import AppKit, SwiftUI, and Kiki packages. It should stay thin and
delegate product presentation to feature code.

### Features

`Features/` owns app-facing product surfaces:

- Menu bar item declarations.
- Settings panes.
- Onboarding windows and first-launch presentation.
- Paywall views, display configuration, and Kiki adapters.
- Feature-specific presentation models that do not need to be reused elsewhere.

Feature code may import SwiftUI and Kiki. Keep reusable package code in Kiki,
and keep lifecycle setup in `App/`.

### Platform

`Platform/` is optional. Create it when the app talks directly to macOS services:

- Pasteboard, window inspection, AirDrop, `NSWorkspace`, StoreKit review prompts,
  launch-at-login wrappers, or other AppKit/CoreGraphics bridges.
- Testable protocols around system APIs.

The starter does not currently have a `Platform/` directory because its system
integration is already provided by Kiki.

### Shared

`Shared/` owns app-local constants and configuration:

- Product name and links.
- App copy, defaults, and future design tokens.
- Lightweight app constants that are not feature behavior.

Shared is not a dumping ground for business rules. If a value belongs only to a
single feature, keep it with that feature.

## Optional Core

`Core/` is not part of the default starter layout. Add it only when there are
pure product rules that can live without SwiftUI, AppKit, Kiki, or app lifecycle
state.

A `Core/` folder is justified when at least one of these is true:

- a CLI, helper, extension, background agent, or another app target consumes the
  same rules;
- rules are branchy enough that deterministic input/output tests would make
  them safer;
- the same rule is otherwise being duplicated across menu, settings, onboarding,
  and paywall routing.

Until then, prefer clear app-target folders over a premature package split.
Avoid creating a separate Swift package unless there is a real reuse or
distribution boundary.

## Testing-First Shape

Architecture should make the cheapest useful test obvious:

- Pure rules: expose deterministic input/output functions and, when useful, a
  small CLI.
- App integration: use Xcode tests and build checks.
- UI entry points: provide fixed launch arguments or scripts that open the
  relevant windows and capture screenshots.
- Risky platform behavior: keep manual smoke checks for permissions, purchase,
  input interception, and recovery paths.

Do not add `Core/` just to say the app is testable. Add it when it lets a test
avoid launching the app or touching platform state.

Before adding a feature or setting, classify it in this order:

1. Feature list: what user-visible behavior or setting is changing?
2. Boundary: Core, Platform, UI, or Manual.
3. Test entry point: Core CLI matrix, Xcode test, UI smoke screenshot, or manual
   release smoke.

Core CLI should stay pure. It may evaluate product rules such as routing,
widths, policy decisions, parsers, and state transitions. It should not read
Accessibility, inspect `NSStatusItem`, make purchases, open windows, or read
`UserDefaults`.

## Action Entry Points

Each user action should have one app-owned entry point. Menu clicks, onboarding
buttons, keyboard shortcuts, launch arguments, and UI smoke scripts should call
that same entry point instead of creating parallel behavior.

Examples:

- `openSettings()` owns Settings opening and uses
  `KikiSettingsOpener.openForMenuBarApp()` while keeping accessory mode.
- `openPaywall()` owns paywall presentation and uses the app's Kiki paywall
  adapter.
- `showOnboarding()` owns onboarding presentation and uses the app's onboarding
  window controller.
- Feature actions such as lock/unlock, reveal/collapse, or paste/drop route
  through the same controller method no matter whether they start from a menu,
  Settings button, shortcut, or test launch argument.

UI smoke CLIs may select a startup scene, but they should wake the real app
action and screenshot the real product surface. Do not add test-only Settings
windows or duplicate SwiftUI row components in the app just to make screenshots
easier. If the app cannot open a Kiki surface cleanly, fix the app's Kiki
integration or add a narrow Kiki API that opens the same surface.

## Kiki Boundary

Kiki packages provide reusable shell and surface mechanics:

- `KikiMenuBar`: status item, native menu items, and popover hosting.
- `KikiSettings`: settings scene shell and common settings rows.
- `KikiPaywall`: optional paywall display shell for paid products, not linked by
  the default starter target.
- `KikiWindow`: AppKit window hosting and window chrome.
- `KikiDesign`: shared glass/material surface treatment.
- `KikiAuthorization`: privacy-permission status, System Settings routing, and
  helper overlay for app-owned setup flows.

The starter owns product state, copy, routing, and replacement points. Do not
move starter-specific plans, entitlement state, or mock behavior into Kiki.

## Commerce Boundary

`KikiCommerceKit` is a separate optional package for paid apps. Add it only
when a copied product has real purchase transport, entitlement refresh,
purchase, and restore behavior. Do not put commerce or RevenueCat code in the
free starter target or in `Kiki_mackit`.

The host app still owns:

- whether the app is free or paid;
- trial and expired-access policy;
- product ids, entitlement ids, and API key wiring;
- paywall routing and pricing copy;
- feature locking and recovery behavior.

The starter has no paid-access switch because its default target is already
free. Paid products should add app-owned access state and
`KikiCommerceKit` after copying the template.

## Debug and Release Boundaries

The starter has no mock entitlement controls. If a paid product adds local
testing controls, keep them behind Debug-only compilation and replace them with
real app-owned access state before shipping.

## Release Readiness

This starter generates its Info.plist from Xcode build settings. The menu bar
identity is visible in the project through settings such as `LSUIElement`, bundle
identifier, display name, and version.

Distribution settings are intentionally not complete in the template. Before
shipping, each product should decide and configure:

- App Sandbox and required entitlements.
- Hardened Runtime and signing identity.
- Notarization and packaging flow.
- Real bundle identifier, app icon, privacy URL, and support links.

## Product Documentation

The starter carries reusable documentation templates in
`Docs/Templates/MacAppDocs/`. New product repos should copy the files that match
their risk level and replace placeholders with product-specific truth.

- Simple apps should keep architecture, testing, and product intent docs.
- Apps with platform risk should also keep decision and issue logs.
- Kiki should be described as API infrastructure; product behavior and recovery
  rules belong to the product app docs.

See `Docs/DocumentationPractices.md` for the exact adoption rule.
