# Onboarding Design Guide

This guide defines the default onboarding shape for Kiki-based Mac menu bar
apps.

Onboarding is app-owned product flow. Kiki packages can provide reusable window,
settings, paywall, and authorization APIs, but the app decides when onboarding
appears, what it says, what state it stores, and what happens when a user skips.

## First Launch Contract

The first launch flow should:

1. explain the product's main job in one screen;
2. show required setup such as Accessibility only when the feature needs it;
3. explain recovery for apps that hide, lock, block, send, or change something;
4. keep paid access optional unless the product is intentionally paid-only;
5. let the user close or skip without trapping the app in a repeat loop.

Do not use onboarding as a hidden permission gate. The app should still launch,
show its menu, open Settings, and expose recovery paths when onboarding is
closed or incomplete.

## State Rule

Keep onboarding state in the app target:

- store `hasCompletedOnboarding` or an equivalent app-local key;
- do not mark onboarding complete just because the window was shown;
- mark it complete when the user finishes, skips, closes intentionally, starts a
  trial, purchases, restores, or follows another deliberately chosen exit path;
- never store onboarding state in Kiki packages;
- keep access, entitlement, and permission state separate from onboarding state.

This avoids the common bug where users see onboarding on every launch after
closing a paywall, cancelling a purchase, or quitting midway through setup.

## Recommended Screens

Simple apps usually need one window with two to three blocks:

- `What it does`: the primary product promise and one or two concrete benefits.
- `Setup`: permission or startup status, with a fix action when needed.
- `Safety`: recovery, local-only behavior, or what the app will not do.

Paid apps can add one optional access block:

- do not spend trial time until the user explicitly starts it;
- offer a skip or finish path;
- show the resulting paid/trial status later in About, not as repeated Settings
  controls.

Platform-risk apps should include recovery copy in onboarding. Examples include
event taps, Accessibility, status item geometry, pasteboard access, global
shortcuts, and anything that can leave the user blocked or confused.

## KikiAuthorization

Use `KikiAuthorization` for the platform authorization mechanism:

```swift
import KikiAuthorization

@MainActor
func openAccessibilitySetup() {
    _ = KikiAuthorizationPanel.accessibility.requestSystemPrompt()
    if !KikiAuthorizationPanel.accessibility.isAuthorized {
        KikiAuthorizationAssistant.shared.present(
            panel: .accessibility,
            instruction: "Turn on the app in Accessibility to enable this feature."
        )
    }
}
```

The app still owns the surrounding copy and consequences. For example, a menu
bar hiding app can keep items revealed until Accessibility is allowed, while an
input lock app can keep the lock button available but report that permission is
needed when the user tries to lock.

## Starter Implementation Rule

The starter's onboarding code is a product-template example, not a Kiki package.
When creating a new app:

- keep the window controller and persistence in the app target;
- use `KikiSingleWindowController` for a small standalone welcome window;
- route permission buttons through `KikiAuthorization`;
- route paid actions through the app's paywall or commerce layer only when the
  app is paid;
- keep Debug-only switches out of onboarding.

## Documentation Rule

If an app has onboarding, record the user-visible contract in docs:

- `PRD.md`: what onboarding must teach and what it must not block;
- `Architecture.md`: where onboarding state lives and which Kiki APIs it calls;
- `DecisionLog.md`: permission, trial, skip, or recovery decisions that would be
  expensive to rediscover later;
- `IssueLog.md`: onboarding bugs that affect first launch, permissions, or
  purchase flow.

## Release Checklist

Before shipping onboarding:

- closing the onboarding window does not show it forever on every relaunch;
- Settings and Quit remain reachable;
- required permissions have a visible status and fix action;
- permission-denied behavior is explicit and recoverable;
- paid apps do not start a trial until the user chooses it;
- free apps contain no Pro, trial, product id, or purchase copy;
- Debug-only testing controls are not visible;
- copy avoids internal words such as entitlement, mock, package, and controller.
