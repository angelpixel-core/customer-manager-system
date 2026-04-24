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

# 🧬 📦 Domain Package (customer_core)

```
packages/customer_core/
├── lib/
│   ├── customer_core.rb              # entrypoint (Zeitwerk root)
│
│   └── customer_core/
│       ├── version.rb
│
│       # 🧠 DOMAIN (pure)
│       ├── domain/
│       │   ├── customer.rb
│       │   ├── value_objects/
│       │   ├── policies/
│       │   └── services/
│
│       # 🎯 APPLICATION (use cases)
│       ├── application/
│       │   ├── use_cases/
│       │   │   ├── create_customer.rb
│       │   │   ├── update_customer.rb
│       │   │   └── delete_customer.rb
│       │
│       │   ├── commands/
│       │   ├── queries/
│       │
│       │   ├── interfaces/           # PORTS
│       │   │   ├── repositories/
│       │   │   ├── event_bus.rb
│       │   │   ├── notifier.rb
│       │   │   └── logger.rb
│       │
│       │   └── dto/
│
│       # 📡 EVENTS (domain events)
│       ├── events/
│       │   ├── customer_created.rb
│       │   ├── customer_updated.rb
│       │   └── customer_deleted.rb
│
│       # 🔌 NO infrastructure here (important)
│
├── spec/                             # pure domain tests (no Rails)
├── customer_core.gemspec
```

# 🧠 Naming

```rb
CustomerCore::Domain::Customer
CustomerCore::Application::UseCases::CreateCustomer
CustomerCore::Application::Interfaces::CustomerRepository
CustomerCore::Events::CustomerCreated
```

# 🚀 🧩 Rails App (apps/admin)

```
apps/admin/
├── app/
│   ├── controllers/
│   │   └── admin/
│
│   ├── admin/                        # ActiveAdmin
│
│   ├── models/                       # ActiveRecord ONLY
│
│   ├── repositories/                 # adapters
│   │   └── active_record/
│
│   ├── events/                       # adapters
│   │   ├── sync_event_bus.rb
│   │   └── faktory_event_bus.rb
│
│   ├── workers/                      # Faktory workers
│
│   ├── services/                     # orchestration (optional)
│
│   ├── integrations/
│   │   ├── n8n/
│   │   └── webhooks/
│
│   └── presenters/
│
├── config/
│   ├── initializers/
│   │   ├── customer_core.rb          # wiring dependencies
│   │   ├── faktory.rb
│   │   └── rodauth.rb
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
