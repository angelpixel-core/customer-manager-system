---
id: ARCHITECTURE
aliases: []
tags: []
---

# 🧠 🧱 Customers Manager System - Architecture Blueprint

## 🎯 Goal

A production-ready SaaS foundation with:

- Domain-driven core (DDD)
- Hexagonal architecture (Ports & Adapters)
- Rails as delivery layer (not business logic)
- Event-driven system (sync + async)
- Ready for multi-tenant + integrations

# 🗂️ 🏗️ Monorepo Structure

```
repo/
├── apps/
│   └── admin/                        # Rails (delivery layer)
│
├── packages/
│   └── customer_core/                # Domain (GEM)
│
├── platform/                         # Infra & cross-cutting concerns
│   ├── events/
│   ├── observability/
│   └── integrations/
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DEMO_RUNBOOK.md
│   └── DECISIONS/
```

# 🧭 North-Star Architecture (Target)

This section defines the target architecture for medium-term evolution.
The sections below document the current implementation state.

```
repo/
├── apps/
│   └── admin/
│       ├── app/
│       │   ├── controllers/
│       │   ├── models/                     # ActiveRecord only
│       │   ├── admin/infrastructure/       # adapters (repo/event bus)
│       │   ├── workers/admin/infrastructure/
│       │   ├── services/                   # optional orchestration
│       │   └── presenters/
│       ├── config/
│       │   ├── initializers/
│       │   │   ├── customer_core.rb        # dependency wiring
│       │   │   ├── faktory.rb
│       │   │   └── rodauth.rb
│       │   └── routes.rb
│       └── db/
│           ├── migrate/
│           ├── schema.rb
│           └── seeds.rb
│
├── packages/
│   └── customer_core/
│       ├── lib/
│       │   ├── customer_core.rb            # Zeitwerk entrypoint
│       │   └── customer_core/
│       │       ├── version.rb
│       │       ├── domain/                 # pure business rules
│       │       │   ├── customer.rb
│       │       │   ├── value_objects/
│       │       │   ├── policies/
│       │       │   └── services/
│       │       ├── application/            # use cases + ports
│       │       │   ├── use_cases/
│       │       │   │   └── customer/
│       │       │   │       ├── create.rb
│       │       │   │       ├── update.rb
│       │       │   │       └── delete.rb
│       │       │   ├── commands/
│       │       │   ├── queries/
│       │       │   ├── interfaces/
│       │       │   │   ├── repositories/
│       │       │   │   ├── event_bus.rb
│       │       │   │   ├── notifier.rb
│       │       │   │   └── logger.rb
│       │       │   └── dto/
│       │       └── events/
│       │           └── customer/
│       │               ├── created.rb
│       │               ├── updated.rb
│       │               └── deleted.rb
│       ├── spec/
│       │   ├── domain/
│       │   └── application/
│       └── customer_core.gemspec
│
├── platform/
│   ├── events/
│   ├── observability/
│   └── integrations/
│
└── docs/
    ├── ARCHITECTURE.md
    ├── DEMO_RUNBOOK.md
    └── DECISIONS/
```

North-star naming:

```rb
CustomerCore::Domain::Customer
CustomerCore::Application::UseCases::Customer::Create
CustomerCore::Application::Interfaces::Repositories::CustomerRepository
CustomerCore::Events::Customer::Created
Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository
Admin::Infrastructure::Events::FaktoryEventBus
```

# 🧬 📦 Domain Package (customer_core)

```
packages/customer_core/
├── lib/
│   ├── customer_core.rb              # entrypoint (Zeitwerk root)
│
│   └── customer_core/
│       ├── version.rb
│       ├── domain/
│       │   └── customer.rb
│       ├── application/
│       │   └── use_cases/
│       │       └── customer/
│       │           └── create.rb
│       └── events/
│           └── customer/
│               └── created.rb
│
│       # 🔌 NO infrastructure here (important)
│
├── spec/                             # pure domain tests (no Rails)
│   ├── domain/customer/customer_spec.rb
│   └── application/customer/create_spec.rb
├── customer_core.gemspec
```

# 🧠 Naming

```rb
CustomerCore::Domain::Customer
CustomerCore::Application::UseCases::Customer::Create
CustomerCore::Events::Customer::Created
```

# 🚀 🧩 Rails App (apps/admin)

```
apps/admin/
├── app/
│   ├── controllers/
│   │   └── customers_controller.rb
│   ├── models/
│   │   └── customer/record.rb
│   ├── admin/
│   │   └── infrastructure/
│   │       ├── repositories/active_record/customer_repository.rb
│   │       └── events/faktory_event_bus.rb
│   └── workers/
│       └── admin/infrastructure/send_welcome_email_worker.rb
│
├── config/
│   ├── initializers/
│   │   ├── faktory.rb
│   │   └── rodauth.rb
│   └── routes.rb
├── db/
│   ├── migrate/
│   ├── schema.rb
│   └── seeds.rb
```

# 🔌 🧠 Dependency Wiring (CRITICAL)

```sh
apps/admin/config/initializers/customer_core.rb
```

# ⚡ 📡 Event System (SYNC + ASYNC)

```sh
platform/events/
├── event.rb
├── event_bus.rb
├── sync/
│   └── in_memory_event_bus.rb
│
├── async/
│   ├── faktory_event_bus.rb
│   └── retry_handler.rb
│
├── serializers/
├── registry/
└── dead_letter_queue/
```

# 🧠 Flow

```
Use Case
  ↓
Domain Event
  ↓
Event Bus
  ↓
Handlers
  ↓
Async Jobs (Faktory)
```

# 🔥 Event Types

| Tipo               | Uso                  |
| ------------------ | -------------------- |
| Domain Events      | Dentro del Core      |
| Integration Events | Hacia n8n / Externos |
| Internal Events    | Métricas / Logging   |

# 🌐 🔗 Integrations (n8n / webhooks)

```
platform/integrations/
├── n8n/
│   ├── client.rb
│   └── event_forwarder.rb
│
├── webhooks/
│   ├── signer.rb
│   ├── dispatcher.rb
│   └── retry_policy.rb
```

## Real Flow

```
CustomerCreated
  ↓
Event Bus
  ↓
Forward to n8n
  ↓
Automation / workflows
```

# 📊 📡 observability

```
platform/observability/
├── logging/
├── metrics/
├── tracing/
└── events_dashboard/
```

---

## Min viable

- structured logs
- event logs
- job status (Faktory)

---

# 🧪 🧬 Testing Strategy

```sh
packages/customer_core/spec/     # domain (unit)
apps/admin/spec/                 # integration
```

Layers

| Layer       | Test        |
| ----------- | ----------- |
| domain      | unit        |
| application | use case    |
| adapters    | integration |
| full flow   | e2e         |

🧠 Reglas de Arquitectura (NO NEGOCIABLES)

1. Domain isolation

```
NO ActiveRecord en domain
NO Rails en domain
NO params en domain
```

2. Use cases only entry point

```
Rails → UseCase → Domain
```

3. Events everywhere

```
Side effects = events
```

4. Adapters only in Rails

```
DB, jobs, APIs → adapters
```

# 🚀 Evolución futura

It can scale direct to:

- multi-tenant SaaS
- event-driven platform
- automation system
- CRM / workflows engine

⸻

# ⚡ TL;DR

👉 packages/ = domains
👉 apps/ = interfaz
👉 platform/ = infraestructure
