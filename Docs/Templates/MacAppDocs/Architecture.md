# Architecture

`<App Name>` is a macOS `<menu bar/window/helper>` app that solves `<user problem>`.

Current solution:

- `<short statement of the app's main mechanism>`
- `<important platform API or Kiki API used>`
- `<key safety/privacy boundary>`

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

`Platform/` owns direct macOS integration:

- `<Accessibility / CGEventTap / NSStatusItem / NSWorkspace / Pasteboard / Sharing>`
- permission checks;
- system API wrappers;
- platform failure states.

This layer should expose app-owned states and actions upward. It should not
contain product copy or purchase policy.

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

