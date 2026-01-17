# Project Aura

Project Aura is a standalone settlement engine that bridges fiat rails (ACH/SEPA) with on-chain stablecoin settlement. It is designed to align with BitGo's API-first, microservices architecture.

## What the Demo Does

Project Aura is split into four demo services that together show the core flow:

1. **API Contract (`api/openapi.yaml`)**: The source of truth for deposit, status, and admin pause endpoints. Idempotency keys are required on write requests to prevent double-mints.
2. **Backend Core (`backend/`)**: Elixir GenServer state machines model each transaction lifecycle. A Postgres ledger captures immutable double-entry entries, while a transaction table holds the current status for fast reads.
3. **Dashboard (`frontend/`)**: A dark-mode command center that presents settlement metrics and live flows (static seed data in this demo).
4. **Mock Bank (`services/mock_bank/`)**: A flaky, delayed bank API for exercising circuit breaker behavior and retry logic.

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

# Mock bank service
cd ../services/mock_bank
npm install
npm start
```

## Design Tenets

- **Idempotency everywhere**: every write request must supply a UUID idempotency key.
- **Double-entry ledger**: no balance columns—only immutable ledger entries.
- **Per-integration circuit breakers**: Bank A downtime must not stop Bank B.

## Demo Readiness Checklist

This demo is ready to run locally with the steps above. To expand beyond the scaffold:

- Wire Phoenix routes/controllers to the OpenAPI contract.
- Persist GenServer state transitions back into `transactions` and `ledger_entries`.
- Add a background cleanup job for idempotency TTL enforcement.
