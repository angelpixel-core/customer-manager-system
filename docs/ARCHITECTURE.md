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

Status convention in this document:

- `Implemented today`: already in code and used in runtime flow.
- `Target / pending`: planned architecture not fully implemented yet.

```
repo/
├── apps/
│   └── admin/
│       ├── app/
│       │   ├── controllers/
│       │   ├── models/                     # ActiveRecord only
│       │   ├── admin/infrastructure/       # adapters (repo + event publishing)
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
│       │       │   │   ├── customer/repository.rb
│       │       │   │   ├── events/publisher.rb
│       │       │   │   ├── events/dead_letter_store.rb
│       │       │   │   ├── events/event_bus.rb     # facade estable sobre Publisher (implemented)
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
CustomerCore::Application::Interfaces::Customer::Repository
CustomerCore::Application::Interfaces::Events::EventBus
CustomerCore::Application::Interfaces::Events::Publisher
CustomerCore::Application::Interfaces::Notifier
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

# 🧰 Callable Interface (`#call`)

Use `#call` as the standard interface for action objects.

Apply to:

- `packages/customer_core/.../application/use_cases/**`
- delivery-layer orchestration services (if introduced)

Do not force `#call` in:

- domain entities/value objects
- repositories/events
- workers (`perform`)
- ActiveRecord models

Callable convention:

```rb
class SomeAction
  def self.call(...)
    new(...).call
  end
end
```

# ✅ Result Convention (Ports/Interfaces)

Application ports/interfaces return `CustomerCore::Application::Result`.

- `Success(value)` for successful operations.
- `Failure(code:, message:, cause:)` for expected adapter/application failures.
- Do not use exceptions as normal control flow between use cases and adapters.

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
│   │       ├── events/faktory_event_bus.rb
│   │       ├── events/rails_dead_letter_store.rb
│   │       └── logging/rails_logger.rb
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

# 🎨 UI Layout Foundation (Current)

The `feat(ui): add clean application layout foundation` commit introduced
the first reusable visual foundation for non-ActiveAdmin pages in `apps/admin`.

## Scope

- Keep business flow unchanged (only presentation layer changes)
- Centralize frontend CSS entry through Vite
- Establish a layered style architecture (tokens → reset → layout → primitives → utilities)

## Files and Conventions

```
apps/admin/app/frontend/
├── entrypoints/
│   └── application.js                # imports ../styles/application.css
└── styles/
    ├── application.css               # root style entrypoint
    ├── base/
    │   ├── _index.css                # base import order
    │   ├── _variables.css            # design tokens (spacing, radius, shadows)
    │   ├── _theme.css                # semantic color palette
    │   ├── _reset.css                # global reset + motion accessibility
    │   ├── _layout.css               # app-shell, topbar, container, form defaults
    │   └── primitives/
    │       ├── _button.css
    │       ├── _link.css
    │       └── _nav.css
    └── utilities/
        └── _index.css
```

## Layout Contract

`apps/admin/app/views/layouts/application.html.erb` now renders a shell with:

- `.app-shell`
- `.app-topbar` (brand + primary nav)
- `.app-main`
- `.app-container`
- `.surface-card`

This is the baseline contract for upcoming componentization work (ViewComponent + Lookbook).

# ⚡ 📡 Event Publishing

## Implemented today

```sh
packages/customer_core/lib/customer_core/application/interfaces/
├── events/
│   ├── publisher.rb
│   ├── dead_letter_store.rb
│   └── event_bus.rb
├── notifier.rb
└── logger.rb

apps/admin/app/admin/infrastructure/
├── events/
│   ├── faktory_event_bus.rb
│   └── rails_dead_letter_store.rb
├── notifications/
│   └── rails_notifier.rb
└── logging/
    └── rails_logger.rb

apps/admin/lib/platform/events/
├── event.rb
├── event_bus.rb
├── registry.rb
├── retry_handler.rb
├── dead_letter_queue.rb
└── metrics.rb

apps/admin/lib/platform/integrations/
├── serializers/
│   ├── event_serializer.rb
│   └── customer_created.rb
└── n8n/
    ├── client.rb
    └── event_forwarder.rb

apps/admin/app/models/platform/events/
└── dead_letter_record.rb
```

## Target / pending

```sh
platform/events/
├── event.rb                              # TODO: pendiente contrato base de evento cross-context
├── event_bus.rb                          # TODO: pendiente mover/adaptar implementacion local de apps/admin/lib/platform/events
├── sync/
│   └── in_memory_event_bus.rb            # TODO: pendiente implementación para desarrollo/tests integrados
├── async/
│   ├── faktory_event_bus.rb              # TODO: pendiente mover/adaptar desde admin/infrastructure/events/faktory_event_bus.rb
│   └── retry_handler.rb                  # TODO: pendiente mover/adaptar desde apps/admin/lib/platform/events/retry_handler.rb
├── serializers/                          # TODO: pendiente serialización de integration events
├── registry/                             # TODO: pendiente mover/adaptar desde apps/admin/lib/platform/events/registry.rb
└── dead_letter_queue/                    # TODO: pendiente mover/adaptar desde apps/admin/lib/platform/events/dead_letter_queue.rb

platform/integrations/
├── serializers/                          # TODO: pendiente mover/adaptar desde apps/admin/lib/platform/integrations/serializers
└── n8n/                                  # TODO: pendiente mover/adaptar desde apps/admin/lib/platform/integrations/n8n
```

# 🧠 Flow

```
Use Case
  ↓
Domain Event
  ↓
EventBus facade
  ↓
Publisher adapter
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
EventBus facade
  ↓
Publisher (FaktoryEventBus)
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
