# Devin Machine Configuration

Use this configuration when setting up this repo in Devin.

## Update Dependencies Command

```bash
cd ~/repos/devin-startup-seq-repro && nvm install 20 && nvm use 20 && pnpm install --frozen-lockfile
```

Or if using npm:

```bash
cd ~/repos/devin-startup-seq-repro && nvm install 20 && nvm use 20 && npm ci
```

## Suggested Fix (add to beginning of Update Dependencies)

To prevent the Node version mismatch bug, consider adding `rm -rf node_modules` before installing:

```bash
cd ~/repos/devin-startup-seq-repro && rm -rf node_modules && nvm install 20 && nvm use 20 && pnpm install --frozen-lockfile
```

This ensures any corrupted `node_modules` from earlier bootstrap steps (running under Node 18) is wiped before installing under the correct Node version.
