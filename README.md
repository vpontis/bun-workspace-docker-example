# Bun Workspace Docker Example

This repository demonstrates an issue with Bun workspaces in Docker builds where you need to copy all workspace packages even when building a single service.

## The Issue

In this monorepo example:
- `packages/api` only depends on `packages/shared`
- `packages/web` depends on `packages/ui`
- When building a Docker image for just the API service, we have to copy ALL packages

## Reproduction Steps

1. Install dependencies:
   bun install

2. Try to build the Docker image:
   docker build -t bun-workspace-example .

   This will fail with:
   error: lockfile had changes, but lockfile is frozen

3. To fix it, you need to copy the entire workspace:
   ```
   # Have to copy everything even though api only needs shared
   COPY . .
   ```

## Desired Behavior

We should be able to:

```
# Only install api and its dependencies
bun install --filter api
```

This would allow efficient Docker builds that only include the necessary packages.

## Current Workarounds

1. Copy entire workspace (inefficient):
   COPY . .

2. Remove --frozen-lockfile (loses reproducibility):
   RUN bun install

3. Split into separate repos (loses monorepo benefits)
