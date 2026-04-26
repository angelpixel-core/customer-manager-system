# RUNBOOK - Create Customers E2E

## Objetivo

Validar manualmente el flujo end-to-end de creacion de clientes:

1. Request HTTP en `apps/admin`
2. `CustomerCore::Application::UseCases::Customer::Create`
3. Persistencia en `Customer::Record`
4. Publicacion de evento `CustomerCore::Events::Customer::Created`
5. Enqueue de worker Faktory

## 0) Requisitos

- Ruby `4.0.3` (asdf)
- Node `22.13.1` en `apps/admin/.tool-versions`
- Docker + Docker Compose

## 1) Preparar entorno

En `apps/admin/platform/environments/local`:

```bash
cp -n env/dev/db.env.example env/dev/db.env
cp -n env/dev/worker.env.example env/dev/worker.env
cp -n env/dev/app.env.example env/dev/app.env
docker compose up -d db worker
docker compose ps
```

## 2) Preparar base de datos y seed

En `apps/admin`:

```bash
cp .env.template .env
bundle exec rails db:prepare
bundle exec rails db:seed
```

Cuenta seed por defecto:

- Email: `admin@example.com`
- Password: `ChangeMe123!`

## 3) Levantar app local

En `apps/admin`:

```bash
bin/dev
```

`Procfile.dev` levanta:

- `web`
- `vite`
- `worker` (Faktory)

## 4) Verificacion funcional (sin UI admin)

Si ActiveAdmin falla por assets, validar el flujo por request directo:

```bash
curl -i -X POST "http://localhost:3000/admin/customers" \
  -d "name=Angel" \
  -d "email=angel@example.com"
```

Esperado:

- HTTP `302` (redirect)
- Se crea registro en DB

Verificar DB:

```bash
bundle exec rails runner "p Customer::Record.order(:id).last&.attributes&.slice('id','name','email')"
```

## 5) Verificacion async (Faktory worker)

En la terminal de `bin/dev`, buscar log del worker:

```text
Sending welcome email to <email>
```

Opcional: revisar UI de Faktory en `http://localhost:7420`.

## 6) Verificacion de tests

Admin:

```bash
bundle exec rspec spec/requests/customer/create_spec.rb
```

Core:

```bash
cd ../../packages/customer_core
bundle exec rspec
```

## 7) Troubleshooting

### Error: `The asset 'active_admin.css' was not found in the load path`

Este error no bloquea validar el flujo E2E de negocio (request + use case + DB + worker).

Accion inmediata recomendada:

1. Validar flujo por `POST /admin/customers` (seccion 4)
2. Registrar issue tecnico para resolver compatibilidad de assets de ActiveAdmin con Propshaft

### DB/worker no disponibles

```bash
cd apps/admin/platform/environments/local
docker compose down
docker compose up -d db worker
```
