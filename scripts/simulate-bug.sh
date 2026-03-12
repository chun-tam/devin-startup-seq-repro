#!/usr/bin/env bash

# This script simulates the Devin bootstrap bug where node_modules gets corrupted
# due to Node version mismatch during automated setup.
#
# Prerequisites:
# - nvm installed
# - Node 18 and Node 20 available via nvm
#
# Usage: ./scripts/simulate-bug.sh

set -e

echo "=== Devin Node Version Mismatch Bug Simulation ==="
echo ""

# Check if nvm is available
if ! command -v nvm &> /dev/null && [ -z "$NVM_DIR" ]; then
    echo "ERROR: nvm is not installed or not sourced"
    echo "Please install nvm and run: source ~/.nvm/nvm.sh"
    exit 1
fi

# Source nvm if needed
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

cd "$(dirname "$0")/.."

echo "Step 1: Clean up any existing node_modules"
rm -rf node_modules package-lock.json pnpm-lock.yaml

echo ""
echo "Step 2: Simulate Devin's default Node 18 environment doing an operation"
echo "        (This represents some bootstrap step running before Update Dependencies)"
nvm use 18 2>/dev/null || { echo "Node 18 not installed. Run: nvm install 18"; exit 1; }
echo "Current Node version: $(node --version)"

# Simulate a partial npm operation under Node 18
# This could be npm install, npm ci, or any npm/pnpm command
echo "Running npm install under Node 18 (simulating early bootstrap)..."
npm install --ignore-engines 2>/dev/null || true

echo ""
echo "Step 3: Now run the 'Update Dependencies' command (as configured by user)"
echo "        nvm use 20 && npm install"
nvm use 20 2>/dev/null || { echo "Node 20 not installed. Run: nvm install 20"; exit 1; }
echo "Current Node version: $(node --version)"
npm install

echo ""
echo "Step 4: Try to run ESLint (as pre-commit hook would)"
echo "        This may fail if babel-plugin-module-resolver is missing/corrupted"
echo ""

if npm run lint; then
    echo ""
    echo "=== RESULT: ESLint succeeded ==="
    echo "The bug did not reproduce this time."
    echo "Note: The bug is intermittent and may require multiple attempts or specific conditions."
else
    echo ""
    echo "=== RESULT: ESLint FAILED ==="
    echo "The bug reproduced! babel-plugin-module-resolver is missing from node_modules."
    echo ""
    echo "Workaround: rm -rf node_modules && nvm use 20 && npm install"
fi
