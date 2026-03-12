# Devin Startup Sequence Node Version Mismatch - Reproduction Repo

This repository reproduces a recurring issue with Devin's automated bootstrap process where `node_modules` becomes corrupted due to Node version mismatch.

## The Bug

During Devin's automated session bootstrap, `node_modules` repeatedly ends up in a corrupted state. Dependencies like `babel-plugin-module-resolver` go missing despite `pnpm install --frozen-lockfile` being part of the startup commands. This causes ESLint (run by pre-commit hooks) to fail with:

```
Cannot find module 'babel-plugin-module-resolver'
```

## Root Cause Hypothesis

1. Devin VM's system-wide default Node version is **18**
2. This repo's `package.json` requires Node **>=20.19.4 <21**
3. Some dependency resolution or npm/pnpm operation runs under the default Node 18 **before** the "Update Dependencies" startup command executes `nvm install 20 && nvm use 20`
4. This partial install under the wrong Node version corrupts `node_modules`
5. Even after `pnpm install --frozen-lockfile` runs under Node 20, some packages end up missing or incorrectly linked

## Reproduction Steps

### On Devin

1. Add this repo to a Devin workspace
2. Set the "Update Dependencies" machine config to:
   ```
   cd ~/repos/devin-startup-seq-repro && nvm install 20 && nvm use 20 && pnpm install --frozen-lockfile
   ```
3. Start a new Devin session
4. Make any code change and attempt to commit
5. **Expected**: Pre-commit hook runs ESLint successfully
6. **Actual**: ESLint fails with "Cannot find module 'babel-plugin-module-resolver'"

### Manual Reproduction (simulating the bug)

```bash
# Simulate Devin's default Node 18 environment doing something first
nvm use 18
pnpm install  # or any npm/pnpm operation

# Then run the "Update Dependencies" command
nvm use 20
pnpm install --frozen-lockfile

# Try to run ESLint
pnpm run lint
# May fail with missing babel-plugin-module-resolver
```

## Expected Behavior

The "Update Dependencies" startup command should reliably install all dependencies under the correct Node version (20) without interference from any earlier bootstrap steps running under the system default Node (18).

## Workaround

When the issue occurs, manually run:
```bash
nvm use 20
rm -rf node_modules
pnpm install --frozen-lockfile
```

## Suggested Fixes for Devin Platform

1. **Option A**: Ensure no npm/pnpm operations run before the user's "Update Dependencies" command
2. **Option B**: Wipe `node_modules` before running "Update Dependencies" if the Node version changed since the last install
3. **Option C**: Set the VM's default Node version based on the repo's engine requirements (from `package.json` or `.nvmrc`) before any other operations run

## Impact

- Wastes ~10+ minutes of session time per occurrence
- Recurring issue across multiple sessions
- Time and tokens spent on environment debugging instead of development work

## Related

- Original issue session: https://app.devin.ai/sessions/8ff0e2cf658c4841a205b28d39a3ca05
- Original repo: bhargi1818/miloza-app
