# turbo-repro-dry-run-self-hosted-cache

Reproduction for a Turborepo bug: since 2.11.4, `turbo run --dry` is much slower when using a self-hosted remote cache.

Created with `npx create-turbo@canary -e with-shell-commands -m pnpm`, plus 100 copies of `pkg-a` (`packages/pkg-001` … `packages/pkg-100`), for 105 `build` tasks.

`docker-compose.yml` runs:

- `cache`: [`ducktors/turborepo-remote-cache`](https://github.com/ducktors/turborepo-remote-cache) 2.14.3.
- `latency`: adds 25ms of network latency to the cache, like a cache that isn't on the same machine.
- `turbo`: runs `time pnpm turbo run build --dry=json` against the cache.

## Reproduce

```sh
TURBO_VERSION=2.11.3 docker compose run --build --rm turbo
TURBO_VERSION=2.11.8-canary.2 docker compose run --build --rm turbo
docker compose down
```

## Expected

The dry run takes about as long on 2.11.8-canary.2 as on 2.11.3.

## Actual

| turbo           | `turbo run build --dry=json` |
| --------------- | ---------------------------- |
| 2.11.3          | ~0.5s                        |
| 2.11.4          | ~6–7s                        |
| 2.11.8-canary.2 | ~6–7s                        |

2.11.4 is the first slow release. From 2.11.4 on, the cache server logs show `POST /v8/artifacts` requests that return 404; 2.11.3 doesn't send them.
