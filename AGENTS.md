# Kiki Menubar Starter Agent Notes

This repository is a starter/template app for wiring the Kiki macOS UI packages into a small menu bar product.

## Architecture Reference

Read `Docs/Architecture.md` before making structural changes. Read
`Docs/DocumentationPractices.md` before creating a new product from this
starter or adding platform-risk behavior to an app created from it. Read
`Docs/SettingsDesignGuide.md` before changing Settings UI or creating a new
app's first Settings window. Read `Docs/OnboardingDesignGuide.md` before adding
first-launch onboarding, permission setup, trial routing, or skip behavior.

The starter is organized as an app-target architecture example that follows the
practical Command Reopen-style layout:

- `App/`: app entry point, AppKit lifecycle, Kiki wiring, and presentation glue.
- `Features/`: SwiftUI surfaces, feature display config, and adapters into Kiki UI.
- `Platform/`: optional system-service wrappers when the app talks directly to macOS APIs.
- `Shared/`: app-local config, copy, links, defaults, and future design tokens.
- `Core/`: optional only; add it for pure rules with a real second consumer or clear platform-free value.

Keep the template boundary clear:

- Do not add Direct distribution logic.
- Use `Kiki_mackit` for UI package examples.
- Use the standalone `RevenueCatCommerceKit` package only for paid-app commerce
  wiring examples.
- Keep app-specific business logic minimal and easy to replace.
- Do not treat the mock entitlement store as reusable commerce architecture.
- Keep Kiki adapters out of optional Core; put them in `Features/` or `App/`.
- Do not create empty architecture folders. Add `Platform/` or `Core/` only
  when the project has code that belongs there.

## Documentation Template Rule

New apps created from this starter should copy the matching docs from
`Docs/Templates/MacAppDocs/` into the product repo's `docs/` or `Docs/`
directory.

- Simple apps should start with `Architecture.md` and `PRD.md`.
- Apps that touch Accessibility, `CGEventTap`, status item geometry,
  activation policy, `NSWorkspace`, pasteboard privacy, or recovery-sensitive
  paywall/access behavior should also keep `DecisionLog.md` and `IssueLog.md`.
- Keep Kiki as API infrastructure in the docs. Product behavior, permissions,
  recovery rules, copy, and access policy belong to the app.
- Do not leave placeholder sections in shipped project docs. Remove irrelevant
  sections or replace them with real product decisions.

## Settings Design Rule

Settings is part of the starter's default product shape. New apps should start
from the guidance in `Docs/SettingsDesignGuide.md`, then remove anything that
does not serve the product.

- Simple apps usually need only `General` and `About`.
- Add `System` only for real permissions, launch behavior, recovery, or macOS
  integration.
- Add `Account`, `Plan`, or `Access` only when the release product has real
  purchase, trial, account, or license behavior.
- Use `StarterAppConfig.includesPaidAccess` to keep free apps free of Paywall,
  Pro status, and mock purchase controls.
- Do not let mock entitlement or debug controls define the release Settings
  layout.
- Prefer Kiki row components over raw SwiftUI controls unless the needed
  component does not exist yet.

## Onboarding Design Rule

Onboarding belongs in the app target, not in Kiki packages. Kiki can provide
window, authorization, paywall, and settings APIs, while the product app owns
copy, persistence, skip behavior, permission consequences, and paid-access
routing.

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
- `xcodebuild test -project KikiMenubarStarter.xcodeproj -scheme KikiMenubarStarter -destination 'platform=macOS,arch=arm64'`
