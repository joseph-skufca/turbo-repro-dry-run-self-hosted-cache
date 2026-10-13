FROM node:24-bookworm

ARG TURBO_VERSION=2.11.8-canary.2

RUN npm install -g pnpm@11.22.0

WORKDIR /repo
COPY . .
RUN pnpm add -w -D turbo@${TURBO_VERSION}

CMD ["bash", "-c", "time pnpm turbo run build --dry=json > /dev/null"]
