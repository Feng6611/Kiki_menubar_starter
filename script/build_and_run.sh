#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-run}"
APP_NAME="KikiMenubarStarter"
PROJECT_NAME="KikiMenubarStarter.xcodeproj"
SCHEME_NAME="KikiMenubarStarter"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DERIVED_DATA_DIR="$ROOT_DIR/build/DerivedData"
APP_BUNDLE="$DERIVED_DATA_DIR/Build/Products/Debug/$APP_NAME.app"
APP_BINARY="$APP_BUNDLE/Contents/MacOS/$APP_NAME"

cd "$ROOT_DIR"

stop_running_app() {
  pkill -TERM -x "$APP_NAME" >/dev/null 2>&1 || true
  pkill -TERM -f "$APP_NAME.app/Contents/MacOS/$APP_NAME" >/dev/null 2>&1 || true
  sleep 0.5
  pkill -KILL -x "$APP_NAME" >/dev/null 2>&1 || true
  pkill -KILL -f "$APP_NAME.app/Contents/MacOS/$APP_NAME" >/dev/null 2>&1 || true
}

stop_running_app

xcodebuild \
  -project "$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration Debug \
  -destination 'platform=macOS' \
  -derivedDataPath "$DERIVED_DATA_DIR" \
  build

open_app() {
  /usr/bin/open -n "$APP_BUNDLE"
}

case "$MODE" in
  build|--build)
    ;;
  run)
    open_app
    ;;
  --debug|debug)
    lldb -- "$APP_BINARY"
    ;;
  --verify|verify)
    open_app
    sleep 1
    pgrep -x "$APP_NAME" >/dev/null
    ;;
  *)
    echo "usage: $0 [run|build|--debug|--verify]" >&2
    exit 2
    ;;
esac
