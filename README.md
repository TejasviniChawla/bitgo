# Project Aura

Project Aura is a standalone settlement engine that bridges fiat rails (ACH/SEPA) with on-chain stablecoin settlement. It is designed to align with BitGo's API-first, microservices architecture.

## Repository Layout

- `api/` OpenAPI contract (source of truth)
- `backend/` Elixir core settlement engine (GenServer state machines + Postgres ledger)
- `frontend/` Next.js dashboard (dark-mode command center)
- `services/` Mock integrations (e.g., flaky bank API)
- `docs/` Architecture and resilience notes

## Quick Start (Local)

```bash
# Start Postgres (example)
docker run --name aura-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:16

# Backend
cd backend
mix deps.get
mix ecto.create
mix ecto.migrate
mix run --no-halt

# Frontend
cd ../frontend
npm install
npm run dev
```

## Design Tenets

- **Idempotency everywhere**: every write request must supply a UUID idempotency key.
- **Double-entry ledger**: no balance columns—only immutable ledger entries.
- **Per-integration circuit breakers**: Bank A downtime must not stop Bank B.
