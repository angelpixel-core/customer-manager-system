# Admin Platform (Local)

This directory contains local infrastructure assets for `apps/admin`.

Hybrid workflow (recommended):
- Run infra in Docker (`postgres`, `worker`)
- Run Rails/Vite/worker locally

Environment files:
- Runtime local app: `apps/admin/.env`
- Docker infra compose: `apps/admin/platform/environments/local/env/dev/*.env`

The `PROJECT_DB_PREFIX` default is `customers_manager_system`.

## Start infrastructure

From `apps/admin/platform/environments/local`:

```sh
cp -n env/dev/db.env.example env/dev/db.env
cp -n env/dev/worker.env.example env/dev/worker.env
cp -n env/dev/app.env.example env/dev/app.env
docker compose up -d db worker
```

To use a specific env profile (default is `dev`):

```sh
ENV_PROFILE=dev docker compose up -d db worker
```

## App runtime (local)

From `apps/admin`:

```sh
cp .env.template .env
bundle exec rails db:prepare
bin/dev
```

If you are not using Procfile tooling, run worker in a separate terminal:

```sh
bundle exec faktory-worker -r ./config/environment.rb
```

## Stop infrastructure

From `apps/admin/platform/environments/local`:

```sh
docker compose down
```
