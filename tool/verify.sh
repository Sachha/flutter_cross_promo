#!/usr/bin/env bash
# Full check of the package: analysis, tests (VM and browser), example app,
# web builds (dart2js and dart2wasm). Can be run from any directory.
#   tool/verify.sh                 everything
#   SKIP_CHROME=1 tool/verify.sh   without the tests in Chrome
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

step() { printf '\n== %s\n' "$1"; }

step "Dependencies"
flutter pub get >/dev/null
(cd example && flutter pub get >/dev/null)

step "Analysis"
flutter analyze

step "No dart:io in lib/"
if grep -rnE "import ['\"]dart:io['\"]" lib; then
  echo "dart:io found in lib/: the package must compile for the web" >&2
  exit 1
fi

step "Tests (VM)"
flutter test

if [[ "${SKIP_CHROME:-0}" != "1" ]]; then
  step "Tests (Chrome)"
  flutter test --platform chrome
fi

step "Example: analysis and tests"
(cd example && flutter analyze && flutter test)

step "Example: web build (dart2js)"
(cd example && flutter build web --no-wasm-dry-run)

step "Example: web build (dart2wasm)"
(cd example && flutter build web --wasm)

printf '\nGREEN\n'
