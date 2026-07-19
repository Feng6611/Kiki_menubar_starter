# Testing

This starter uses a testing-first shape based on a maintained feature
inventory. Each new feature or setting should first be listed, connected to a
user journey, then tested at the cheapest reliable layer.

## Feature Inventory

| ID | Feature / setting | User goal | Entry point | States | Boundary | Tests |
| --- | --- | --- | --- | --- | --- | --- |
| F-001 | Menu action routing | User can trigger the main app action from the menu bar | Menu extra | Available / disabled / routed | Core when branchy | J-001 |
| F-002 | Settings layout and copy | User can understand and change app behavior | Settings window | Default / changed | UI | J-002 |
| F-003 | Onboarding Feature routing | New user can reach first useful state | Kiki Onboarding Feature | First run / completed / closed / routed to Settings | UI/App | J-003 |
| F-004 | Composition-owned app shell | User can reach the app controls from the accessory app | Menu bar / Settings | Accessory / opened | App/UI | J-004 |

## Agent-Friendly Journey Cases

| Case ID | Journey | Covers | Boundary | Preconditions | Steps | Expected evidence | Cleanup |
| --- | --- | --- | --- | --- | --- | --- | --- |
| J-001 | Use the menu bar action | F-001 | Core/App | Known reduced state | Run Core matrix or menu model test | JSON action/title or passing test | None |
| J-002 | Review and change settings | F-002 | UI | Debug build | Open fixed Settings scene and screenshot | Nonblank screenshot with expected tab/copy | Close app |
| J-003 | First-run onboarding | F-003 | UI/App | Fresh or reset onboarding state | Open the real Kiki Onboarding route | Screenshot plus coordinator completion test | Reset completion store |
| J-004 | Open the real Settings surface | F-004 | UI/App | Debug build | Open Settings from the menu bar | Real Settings window with General/About | Close app |

## Verification Matrix

| Feature / setting | Boundary | Core CLI | Xcode tests | UI smoke | Manual release smoke |
| --- | --- | --- | --- | --- | --- |
| Menu action routing | Core when branchy | Optional | Required | Optional | No |
| Settings layout and copy | UI | No | Optional | Required when changed | No |
| Onboarding Feature routing | UI/App | No | Required | Required when changed | Close/route path |
| Composition-owned app shell | UI/App | No | Required | Settings screenshot | Accessory app smoke |

Boundary values:

- `Core`: deterministic product rules with plain inputs and outputs.
- `Platform`: direct macOS services such as AppKit, Accessibility,
  CoreGraphics, pasteboard, or activation policy.
- `UI`: SwiftUI/Kiki presentation, layout, copy, and window entry points.
- `Manual`: behavior that depends on real permissions, purchases, input
  interception, or fragile system state.

For a generated Apple paid app, the default Debug proof is a real Apple
Development-signed Sandbox build using its `appl_` key. The run script must fail
for `test_`, unsigned, or ad-hoc products and must verify the final Bundle ID and
Info.plist injection before launch. Do not automate the purchase confirmation;
manually verify purchase and Restore with a Sandbox Apple Account and confirm
the transaction in RevenueCat Sandbox data.

## Default Commands

Use commands from the product app's `AGENTS.md` first. A typical Kiki-based app
uses:

```sh
git diff --check
xcodebuild test -project <Project>.xcodeproj -scheme <Scheme> -destination 'platform=macOS,arch=arm64'
```

If the product has a Core CLI, add:

```sh
./script/<app>_core.sh matrix
```

If the product has UI smoke entry points, add:

```sh
./script/<app>_ui.sh smoke
```

UI smoke launch arguments should wake the same app action a real user action
would wake. For Settings, this means calling the app's `openSettings()` and
capturing the real Kiki/SwiftUI Settings scene. Do not add test-only Settings
windows, duplicate panes, or alternate row components for screenshots.

## Maintenance Rule

When adding a feature or setting:

1. update the Feature Inventory;
2. add or update Agent-friendly journey cases;
3. put pure rules in Core only when they have real branching or a second
   consumer such as CLI, helper, extension, or another target;
4. add or update Core CLI matrix cases when Core changes;
5. add UI smoke screenshots when user-visible Settings, onboarding, paywall, or
   About surfaces change;
6. keep real permissions, purchases, input interception, and menu bar geometry
   as manual release smoke unless a safe automation already exists.
