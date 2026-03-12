#!/bin/bash
set -euo pipefail

VERSION=$(gh release list -R fizzbee-io/fizzbee --limit 1 --json tagName --jq '.[0].tagName | ltrimstr("v")')

ARM_SHA=$(gh release view "v${VERSION}" -R fizzbee-io/fizzbee --json assets \
  --jq '.assets[] | select(.name | test("macos_arm")) | .digest | ltrimstr("sha256:")')

X86_SHA=$(gh release view "v${VERSION}" -R fizzbee-io/fizzbee --json assets \
  --jq '.assets[] | select(.name | test("macos_x86")) | .digest | ltrimstr("sha256:")')

echo "Updating to v${VERSION}"
echo "  arm: ${ARM_SHA}"
echo "  x86: ${X86_SHA}"

FORMULA="$(dirname "$0")/fizzbee.rb"

sed -i '' \
  -e "s|version \".*\"|version \"${VERSION}\"|" \
  -e "s|fizzbee-v[^/]*/fizzbee-v[^-]*-macos_arm|fizzbee-v${VERSION}/fizzbee-v${VERSION}-macos_arm|" \
  -e "s|fizzbee-v[^/]*/fizzbee-v[^-]*-macos_x86|fizzbee-v${VERSION}/fizzbee-v${VERSION}-macos_x86|" \
  "$FORMULA"

# Update sha256 values — replace old arm sha first, then x86
OLD_ARM_SHA=$(grep -A1 'macos_arm' "$FORMULA" | grep sha256 | awk '{print $2}' | tr -d '"')
OLD_X86_SHA=$(grep -A1 'macos_x86' "$FORMULA" | grep sha256 | awk '{print $2}' | tr -d '"')

sed -i '' \
  -e "s|${OLD_ARM_SHA}|${ARM_SHA}|" \
  -e "s|${OLD_X86_SHA}|${X86_SHA}|" \
  "$FORMULA"

echo "Done. fizzbee.rb updated."
