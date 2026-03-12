#!/usr/bin/env bash

# Verification script to check if the environment is correctly set up
# Run this after the Update Dependencies command to verify node_modules integrity

set -e

echo "=== Environment Verification ==="
echo ""

echo "1. Node version check:"
NODE_VERSION=$(node --version)
echo "   Current: $NODE_VERSION"

NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1 | tr -d 'v')
if [ "$NODE_MAJOR" -ge 20 ] && [ "$NODE_MAJOR" -lt 21 ]; then
    echo "   ✓ Node version is correct (>=20, <21)"
else
    echo "   ✗ Node version mismatch! Expected >=20 <21, got $NODE_VERSION"
    echo "   Run: nvm use 20"
    exit 1
fi

echo ""
echo "2. Critical dependency check:"

# Check babel-plugin-module-resolver
if [ -d "node_modules/babel-plugin-module-resolver" ]; then
    echo "   ✓ babel-plugin-module-resolver is installed"
else
    echo "   ✗ babel-plugin-module-resolver is MISSING!"
    echo "   This is the bug - run: rm -rf node_modules && npm install"
    exit 1
fi

# Check eslint
if [ -d "node_modules/eslint" ]; then
    echo "   ✓ eslint is installed"
else
    echo "   ✗ eslint is MISSING!"
    exit 1
fi

# Check husky
if [ -d "node_modules/husky" ]; then
    echo "   ✓ husky is installed"
else
    echo "   ✗ husky is MISSING!"
    exit 1
fi

echo ""
echo "3. ESLint execution check:"
if npm run lint --silent 2>/dev/null; then
    echo "   ✓ ESLint runs successfully"
else
    echo "   ✗ ESLint failed to run!"
    exit 1
fi

echo ""
echo "=== All checks passed! Environment is correctly set up. ==="
