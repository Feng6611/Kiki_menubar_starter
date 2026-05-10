# Kiki Menubar Starter Agent Notes

This repository is a starter/template app for wiring the Kiki macOS UI packages into a small menu bar product.

## Architecture Reference

Read `Docs/Architecture.md` before making structural changes. The starter is
organized as an app-target architecture example that follows the practical
Command Reopen-style layout:

- `App/`: app entry point, AppKit lifecycle, Kiki wiring, and presentation glue.
- `Features/`: SwiftUI surfaces, feature display config, and adapters into Kiki UI.
- `Platform/`: optional system-service wrappers when the app talks directly to macOS APIs.
- `Shared/`: app-local config, copy, links, defaults, and future design tokens.
- `Core/`: optional only; add it for pure rules with a real second consumer or clear platform-free value.

Keep the template boundary clear:

- Do not add Direct distribution logic.
- Use `Kiki_mackit` for UI package examples.
- Use the standalone `RevenueCatCommerceKit` package for commerce wiring examples.
- Keep app-specific business logic minimal and easy to replace.
- Do not treat the mock entitlement store as reusable commerce architecture.
- Keep Kiki adapters out of optional Core; put them in `Features/` or `App/`.
- Do not create empty architecture folders. Add `Platform/` or `Core/` only
  when the project has code that belongs there.

Recommended verification after changes:

- `git diff --check`
- `xcodebuild test -project KikiMenubarStarter.xcodeproj -scheme KikiMenubarStarter -destination 'platform=macOS,arch=arm64'`
