FROM oven/bun:1.1.42-alpine

WORKDIR /app

# Try to only copy needed packages (this will fail)
COPY package.json bun.lockb ./
COPY packages/api/package.json ./packages/api/
COPY packages/shared/package.json ./packages/shared/

# This fails because the lockfile references all workspace packages
RUN bun install --frozen-lockfile

COPY packages/api ./packages/api
COPY packages/shared ./packages/shared

CMD ["bun", "run", "start"]
