# Architecture

`<App Name>` is a macOS `<menu bar/window/helper>` app that solves `<user problem>`.

Current solution:

- `<short statement of the app's main mechanism>`
- `<important platform API or Kiki API used>`
- `<key safety/privacy boundary>`

## Architecture Decision

Use the smallest structure that makes ownership and tests clear.

- Visible UI: SwiftUI.
- System integration: AppKit/CoreGraphics wrappers at the edge.
- Complex windows/menus: AppKit container with SwiftUI content.
- Pure product rules: optional `Core/` only when there is enough logic or a
  second consumer such as a CLI, helper, extension, or another target.

Do not keep folders just because the starter mentions them. Remove sections or
directories that do not match the current app.

## Boundaries

### App

`App/` owns application startup and top-level wiring:

- SwiftUI `App` entry point.
- `NSApplicationDelegate` or app lifecycle coordinator.
- Long-lived controllers and app-owned state.
- Wiring from user actions to features and platform services.

### Features

`Features/` owns user-facing product surfaces:

- menu bar views or menu models;
- settings panes;
- onboarding or paywall presentation;
- feature-specific display models.

Feature code may import SwiftUI and Kiki. It should not own direct platform
lifecycles such as event taps, Accessibility probes, or status item geometry.

### Platform

`Platform/` is optional. Create it only when the app owns direct macOS
integration:

- `<Accessibility / CGEventTap / NSStatusItem / NSWorkspace / Pasteboard / Sharing>`
- permission checks;
- system API wrappers;
- platform failure states.

This layer should expose app-owned states and actions upward. It should not
contain product copy or purchase policy.

### Core

`Core/` is optional. Create it only for pure product rules that can run without
SwiftUI, AppKit, Kiki, `UserDefaults`, RevenueCat, or system permissions.

Good candidates:

- menu/action routing rules;
- access-state decisions;
- parsers or formatters with real branching;
- policy evaluation shared by multiple UI surfaces or a CLI.

Avoid Core for:

- view models that need SwiftUI or Kiki;
- app lifecycle, windows, and menu bar setup;
- platform permission checks;
- purchase transport or entitlement refresh;
- constants used by only one feature.

### Shared

`Shared/` owns app-local constants and simple value types:

- app name, bundle id, links;
- defaults keys;
- product copy;
- lightweight design tokens if needed.

## Kiki Boundary

Kiki provides reusable API infrastructure:

- `KikiSettings`: `<used for>`
- `KikiMenuBar`: `<used for>`
- `KikiWindow`: `<used for>`
- `KikiPaywall`: `<used for>`
- `KikiOverlay`: `<used for>`
- `KikiTriggerCorner`: `<used for>`

This app owns:

- product-specific behavior;
- permissions and failure strategy;
- purchase/trial/access rules;
- product copy and routing.

Do not move `<app-specific behavior>` into Kiki.

## Platform Permissions

| Permission/API | Why it is needed | Failure behavior | Explicitly not used |
| --- | --- | --- | --- |
| `<Permission/API>` | `<reason>` | `<safe fallback>` | `<not used>` |

## Safety Model

- `<safety invariant 1>`
- `<safety invariant 2>`
- `<recovery path that must always work>`
- `<what happens on app quit/crash/failure>`

## Testing-First Shape

Use the cheapest reliable proof for each layer:

- Pure rules: deterministic unit tests and optional CLI output.
- App integration: Xcode tests and build.
- UI entry points: launch fixed scenes and capture screenshots.
- Risky platform behavior: manual smoke checks for real permissions, real
  input interception, real purchases, and recovery paths.

Only add a CLI when it tests product rules without launching the app. UI smoke
CLIs should open windows and produce screenshots; they should not perform
dangerous local actions.

## Action Entry Points

Each user action should have one app-owned entry point. Menu clicks, onboarding
buttons, keyboard shortcuts, launch arguments, and UI smoke scripts should call
that same entry point instead of creating parallel behavior.

Examples:

- `openSettings()` owns Settings opening and uses `KikiSettingsOpener`.
- `openPaywall()` owns paywall presentation and uses the app's Kiki paywall
  adapter.
- `<feature action>` routes through the same controller method whether it starts
  from a menu, Settings button, shortcut, or test launch argument.

UI smoke CLIs may select a startup scene, but they should wake the real app
action and screenshot the real product surface. Do not add test-only Settings
windows or duplicate SwiftUI row components. If the app cannot open a Kiki
surface cleanly, fix the app's Kiki integration or add a narrow Kiki API that
opens the same surface.

## Non-Goals

- `<thing intentionally not supported>`
- `<permission intentionally not requested>`
- `<advanced feature parked for later>`

## Verification

```sh
git diff --check
xcodebuild test -project <Project>.xcodeproj -scheme <Scheme> -destination 'platform=macOS,arch=arm64'
./script/build_and_run.sh --verify
```

If the app has a `Core/` CLI or UI smoke script, list those commands here and
keep release-only manual checks explicit.
