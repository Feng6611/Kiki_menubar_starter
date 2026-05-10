# Architecture

This starter is a small menu bar app template. Its structure follows the
practical shape used by Command Reopen: keep the app shell thin, group product
surfaces by feature, isolate system services only when they appear, and avoid a
heavy `Core/` layer until there is a real second consumer.

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

A separate Core package is justified when there is a real second consumer, such
as a CLI, helper, extension, background agent, or another app target. Until then,
prefer clear app-target folders over a premature package split.

## Kiki Boundary

Kiki packages provide reusable shell and surface mechanics:

- `KikiMenuBar`: status item, native menu items, and popover hosting.
- `KikiSettings`: settings scene shell and common settings rows.
- `KikiPaywall`: paywall display shell and optional window presenter.
- `KikiWindow`: AppKit window hosting and window chrome.
- `KikiDesign`: shared glass/material surface treatment.

The starter owns product state, copy, routing, and replacement points. Do not
move starter-specific plans, entitlement state, or mock behavior into Kiki.
