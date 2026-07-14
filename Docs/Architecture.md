# Architecture

Kiki Menubar Starter is the smallest free menu bar app that demonstrates the
workspace's Product App architecture. It is a composition example, not a
parallel runtime framework.

## Dependency Direction

```text
Starter App
  ├── AppDefinition                 product identity, copy, URLs, stable keys
  ├── AppComposition                long-lived objects and Kit coordinators
  ├── AppRouter                     cross-feature presentation and app actions
  ├── AppLifecycleCoordinator       startup, menu bar lifetime, termination
  └── Features                      product content and action adapters
         │
         └── Kiki Feature APIs      window, navigation, chrome, persistence mechanism
```

The app depends on Kit. Kit never imports the app or knows product controllers,
storage keys, copy, or business policy.

## App Roles

### `StarterAppDefinition`

Owns immutable product facts:

- app and status-item names;
- website, feedback, and repository URLs;
- Settings, status-item, and Onboarding stable keys;
- product-owned onboarding copy.

It contains no window, navigation, or mutable runtime state.

### `StarterAppComposition`

Is the composition root. It creates exactly one Settings coordinator, one
Onboarding completion store/coordinator, one Router, and one Lifecycle
coordinator. It contains construction only; product actions live in the Router.

### `StarterAppRouter`

Owns cross-feature actions such as opening Settings, presenting Onboarding, and
quitting. Feature views and menu items call the Router instead of opening
windows directly.

### `StarterAppLifecycleCoordinator`

Owns application startup and teardown. It sets accessory activation, roots the
Kiki menu-bar controller, builds product menu items, and asks the Router to show
first-launch Onboarding. `StarterAppDelegate` only forwards lifecycle events.

## Feature Ownership

The Starter uses complete Kiki Features by default:

- Settings: `KikiSettingsCoordinator` + `KikiSettingsCoordinatorView` register
  and open the native SwiftUI `Settings {}` window. The app owns tabs and pane
  content.
- About: `KikiStandardAboutPane` owns the standard identity/link shape. The app
  supplies metadata and URLs.
- Onboarding: `KikiOnboardingCoordinator` owns the window, navigation, and
  completion-store mechanism. The app supplies the completion key, close
  policy, copy, and the `Open Settings` route.
- Menu bar: `KikiMenuBarController` owns `NSStatusItem` and menu plumbing. The
  app supplies menu ordering, labels, and actions.

The Onboarding flow uses one `.custom` step because the Starter preserves two
different exits: `Done` completes and closes, while `Open Settings` completes
and routes to Settings. The custom step still uses `KikiOnboardingScaffold`; it
does not own a second window or navigation state machine.

## Optional Layers

`Core/`, `Platform/`, `Shared/`, and `PaywallContent/` are not mandatory parts
of every app:

- Add `Core/` only for pure rules with meaningful branching or a real second
  consumer such as a CLI, helper, extension, or another target.
- Add `Platform/` when the product directly wraps macOS services such as
  Accessibility, CoreGraphics, pasteboard, `NSWorkspace`, or StoreKit review.
- Add `Shared/` only for values genuinely shared by multiple features that do
  not belong in `AppDefinition`.
- Add `PaywallContent/` and `KikiCommerceKit` only to a paid generated product.

Do not create empty folders to imitate a large-app architecture.

## Free and Paid Boundaries

The checked-in Starter target is always free and links only the required Base
Kit products: `KikiSettings`, `KikiMenuBar`, and `KikiOnboarding`.

Paid products are compile-time variants generated from the Starter. They add
`KikiCommerceKit`, app-owned access policy and identifiers, and a paywall route.
There is no runtime `isPaidApp` switch and no mock entitlement state in the free
target.

## Verification Boundary

- Pure app-owned rules: focused unit or CLI tests when such rules exist.
- Composition and Feature wiring: Xcode tests.
- Settings, Onboarding, About, and MenuBar presentation: real-route UI smoke.
- Permissions, purchases, signing, and notarization: manual release smoke.

The current repository has Xcode tests for menu mapping and composition-owned
Feature coordinators. The generator and screenshot UI-smoke pipeline remain
workspace migration work; they are not claimed as complete here.
