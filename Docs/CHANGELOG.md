# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Changed
- Refactored the default target into a genuinely free Base Kit template:
  removed RevenueCat/commerce dependencies, paywall and mock entitlement
  surfaces, and split onboarding state, window ownership, and welcome content
  into focused app files.
- Kept the default product shape to menu bar, General/About Settings, and a
  recoverable welcome window; paid products add `KikiCommerceKit` separately.
- Kept the default Settings opener in accessory mode so starter-based menu bar
  apps do not show a temporary Dock icon when opening Settings.
- Documented Debug-only mock entitlement controls and release-readiness checks.
- Hid mock entitlement menu controls from Release builds.
- Made menu model tests resilient to separator placement.

## [1.0.0] — 2025-05-16

### Added
- Menu bar app shell with KikiMenuBarController.
- Settings window with General, Account, About tabs.
- Paywall view with plan cards, mock purchase, and restore.
- MockEntitlementStore with free/trial/pro state transitions.
- StarterAppConfig for centralized product copy and links.
- Unit tests for menu model, entitlement transitions, and plan mapping.
- Architecture documentation in Docs/Architecture.md.
