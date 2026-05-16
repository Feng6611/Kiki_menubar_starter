# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Changed
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
