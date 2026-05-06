# Kiki Menubar Starter Agent Notes

This repository is a starter/template app for wiring the Kiki macOS UI packages into a small menu bar product.

Keep the template boundary clear:

- Do not add Direct distribution logic.
- Use `Kiki_mackit` for UI package examples.
- Use the standalone `RevenueCatCommerceKit` package for commerce wiring examples.
- Keep app-specific business logic minimal and easy to replace.

Recommended verification after changes:

- `xcodebuild test -project KikiMenubarStarter.xcodeproj -scheme KikiMenubarStarter -destination 'platform=macOS,arch=arm64'`
