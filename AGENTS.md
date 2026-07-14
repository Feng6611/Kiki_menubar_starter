# Kiki Menubar Starter Agent Notes

This repository is a starter/template app for wiring the Kiki macOS UI packages into a small menu bar product.

## Architecture Reference

Read `Docs/Architecture.md` before making structural changes. Read
`Docs/DocumentationPractices.md` before creating a new product from this
starter or adding platform-risk behavior to an app created from it. Read
`Docs/Testing.md` before adding features, settings, Core CLI cases, UI smoke
entry points, or release smoke checks. Read
`Docs/SettingsDesignGuide.md` before changing Settings UI or creating a new
app's first Settings window. Read `Docs/OnboardingDesignGuide.md` before adding
first-launch onboarding, permission setup, trial routing, or skip behavior.

The starter is organized as an app-target architecture example that follows the
practical Command Reopen-style layout:

- `App/`: `AppDefinition`, `AppComposition`, `AppRouter`, lifecycle coordinator,
  app entry point, and thin AppDelegate forwarding.
- `Features/`: SwiftUI surfaces, feature display config, and adapters into Kiki UI.
- `Platform/`: optional system-service wrappers when the app talks directly to macOS APIs.
- `Shared/`: optional values genuinely shared by multiple features; product
  identity, copy, URLs, and stable keys belong in `AppDefinition` by default.
- `Core/`: optional only; add it for pure rules with a real second consumer or clear platform-free value.

Keep the template boundary clear:

- Do not add Direct distribution logic.
- Use `Kiki_mackit` for UI package examples.
- Keep the starter free and Commerce-free. Paid products add
  `KikiCommerceKit` only after copying the template and defining real access
  rules.
- Keep app-specific business logic minimal and easy to replace.
- Do not add mock entitlement or paywall state to the default starter target.
- Keep Kiki adapters out of optional Core; put them in `Features/` or `App/`.
- Do not create empty architecture folders. Add `Platform/` or `Core/` only
  when the project has code that belongs there.
- Keep the four App roles because they define the composition contract. Do not
  force optional `Core/`, `Platform/`, `Shared/`, or paid folders into products
  without code that belongs there.
- Prefer test seams over abstract layers: pure rules can move to `Core/` and a
  CLI; UI and AppKit behavior should stay in the app and be verified by Xcode
  tests or screenshot smoke.
- For every new feature or setting, update the Feature Inventory first, connect
  it to an Agent-friendly user journey test case, then classify the verification
  boundary as Core, Platform, UI, or Manual.
- UI smoke launch arguments must wake the same app action a real user action
  wakes. Do not create test-only Settings windows, duplicate panes, or alternate
  row components for screenshots.
- Menu bar apps should open Settings through
  `KikiSettingsOpener.openForMenuBarApp()` while keeping accessory mode. Do not
  switch to Dock-visible regular mode just to foreground Settings.

## Documentation Template Rule

New apps created from this starter should copy the matching docs from
`Docs/Templates/MacAppDocs/` into the product repo's `docs/` or `Docs/`
directory.

- Simple apps should start with `Architecture.md` and `PRD.md`.
- Apps with any meaningful features or settings should also keep `Testing.md`.
- Apps that touch Accessibility, `CGEventTap`, status item geometry,
  activation policy, `NSWorkspace`, pasteboard privacy, or recovery-sensitive
  paywall/access behavior should also keep `DecisionLog.md` and `IssueLog.md`.
- Keep Kiki as API infrastructure in the docs. Product behavior, permissions,
  recovery rules, copy, and access policy belong to the app.
- Do not leave placeholder sections in shipped project docs. Remove irrelevant
  sections or replace them with real product decisions.
- In `Architecture.md`, explain which layers are intentionally absent. A simple
  app can say it has no `Core/` or `Platform/` yet.

## Settings Design Rule

Settings is part of the starter's default product shape. New apps should start
from the guidance in `Docs/SettingsDesignGuide.md`, then remove anything that
does not serve the product.

- Simple apps usually need only `General` and `About`.
- Add `System` only for real permissions, launch behavior, recovery, or macOS
  integration.
- Add `Account`, `Plan`, or `Access` only when the release product has real
  purchase, trial, account, or license behavior.
- Keep the default Settings shape free of Paywall, Pro status, and purchase
  controls. A paid product may add an access row only after it introduces real
  commerce state.
- Do not let mock entitlement or debug controls define the release Settings
  layout.
- Start with `KikiSettingsCoordinatorView` and `KikiStandardAboutPane`. Use
  lower-level Kiki rows inside app-owned pane content only where needed.

## Onboarding Design Rule

Onboarding uses `KikiOnboardingCoordinator` as the default Feature. Kiki owns
the window, navigation, scaffold, and completion-store mechanism; the product
app owns copy, completion keys, legacy migration, close/skip policy,
permission consequences, and paid-access routing.

- Keep onboarding skippable and recoverable; do not make it a hidden permission
  gate.
- Store only app-local completion state such as `hasCompletedOnboarding`.
- Keep onboarding completion separate from permission state and paid access.
- Use `KikiAuthorization` for Accessibility or Screen Recording setup instead
  of hardcoded System Settings URLs.
- Start trials or purchases only from an explicit user action, and keep paid
  status in About.

Recommended verification after changes:

- `git diff --check`
- update the product's Feature Inventory and journey test cases when behavior changes
- `xcodebuild test -project KikiMenubarStarter.xcodeproj -scheme KikiMenubarStarter -destination 'platform=macOS,arch=arm64'`
