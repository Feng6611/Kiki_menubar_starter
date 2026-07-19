# Testing

`<App Name>` uses testing based on a maintained feature inventory. Each feature
should connect to a user journey, then name the cheapest reliable proof while
keeping risky real macOS behavior explicit.

## Feature Inventory

| ID | Feature / setting | User goal | Entry point | States | Boundary | Tests |
| --- | --- | --- | --- | --- | --- | --- |
| `F-001` | `<feature>` | `<why the user cares>` | `<menu/settings/onboarding>` | `<key states>` | `<Core / Platform / UI / Manual>` | `<case IDs>` |

Rules:

- One row per meaningful user-facing feature, setting, or state transition.
- Do not list internal helpers unless they change user-visible behavior.
- Link feature rows to journey or feature test case IDs.

## Agent-Friendly Journey Cases

| Case ID | Journey | Covers | Boundary | Preconditions | Steps | Expected evidence | Cleanup |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `J-001` | `<user flow>` | `<feature IDs>` | `<Core / Platform / UI / Manual>` | `<known state>` | `<commands or actions>` | `<JSON/screenshot/text/log/state>` | `<reset>` |

Rules:

- Start from the user's natural workflow, not the implementation file.
- Prefer evidence an Agent can verify: JSON output, exit code, screenshot path,
  stable window title, stable text, log marker, or persisted value.
- Split a journey when it crosses Core, UI, platform, and manual boundaries.

## Verification Matrix

| Feature / setting | Boundary | Core CLI | Xcode tests | UI smoke | Manual release smoke |
| --- | --- | --- | --- | --- | --- |
| `<feature>` | `<Core / Platform / UI / Manual>` | `<command or No>` | `<coverage>` | `<screenshot or No>` | `<real-world check or No>` |

Boundary values:

- `Core`: deterministic product rules with plain inputs and outputs.
- `Platform`: AppKit, Accessibility, CoreGraphics, pasteboard, activation
  policy, event taps, or other direct macOS services.
- `UI`: SwiftUI/Kiki presentation, layout, copy, and windows.
- `Manual`: real permissions, purchases, input interception, menu bar geometry,
  or recovery paths that should not be fully automated.

## Core CLI

Use only for pure product rules. Do not read platform state or launch the app.

```sh
./script/<app>_core.sh evaluate <options>
./script/<app>_core.sh matrix
```

## App Integration

```sh
xcodebuild test -project <Project>.xcodeproj -scheme <Scheme> -destination 'platform=macOS,arch=arm64'
xcodebuild build -project <Project>.xcodeproj -scheme <Scheme> -configuration Debug -destination 'platform=macOS,arch=arm64'
```

For an Apple paid app, Debug defaults to Apple Sandbox, not RevenueCat Test
Store. Use the same `appl_` public SDK key as Release, keep it in an ignored
xcconfig/CI setting, require Apple Development signing, and verify the final App
Bundle's key and Bundle ID before launch. Never add
`CODE_SIGNING_ALLOWED=NO` to the Sandbox run path.

## UI Smoke

Use fixed launch arguments or scripts that open windows and capture screenshots.
The fixed argument should only choose the startup scene; the app should still
call the same entry point a real user action calls. For example, a Settings
smoke command should trigger the app's `openSettings()` action and capture the
real Kiki/SwiftUI Settings scene.

Do not create test-only windows, duplicate Settings pages, or alternate row
components for smoke screenshots. Do not perform dangerous local actions.

```sh
./script/<app>_ui.sh smoke
```

## Release Smoke

Before release, run:

1. Confirm feature inventory and journey cases match the shipped behavior.
2. Core CLI matrix, if present.
3. Full Xcode tests.
4. Debug build.
5. UI smoke screenshots for changed user-facing surfaces.
6. For paid apps, verify the Debug bundle has a valid Apple Development
   signature and uses the expected `appl_` key.
7. Manual checks for Sandbox purchase/Restore, real permissions, platform
   integration, and recovery paths.
