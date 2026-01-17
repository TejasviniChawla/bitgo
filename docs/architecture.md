# Project Aura Architecture

## Performance & Resilience Focus

### Transaction Actor Model
- Each transaction is represented by a dedicated GenServer process that owns the state machine.
- Processes are supervised under `Aura.TransactionSupervisor`, ensuring failed transactions restart without impacting others.
- Transaction process state is persisted to Postgres as a status column on `transactions` and reconciled on restart.

### Status Column + Ledger Entries
- `transactions.status` captures the current state of the transaction.
- `ledger_entries` holds immutable double-entry bookkeeping records for every movement.
- Balancing rule: for each transaction, the sum of debit amounts equals the sum of credit amounts.

### Circuit Breaker (Per Bank Integration)
- `Aura.CircuitBreaker` tracks failures per `bank_integration` on a rolling window.
- Once a failure threshold is reached, only that integration is halted.
- Other integrations continue to process normally.

## Idempotency Store Strategy

### Schema
- `idempotency_store` stores the idempotency key, request hash, cached response, and expiration time.
- `request_hash` is SHA-256 of the canonicalized request payload + endpoint.

### Bottleneck Mitigation
- Unique index on `key` prevents duplicates.
- `expires_at` index enables TTL cleanup by a background job.
- Suggested TTL: 24 hours for financial operations, configurable per endpoint.

### Hashing Guidance
1. Normalize request JSON by sorting keys and removing whitespace.
2. Concatenate HTTP method + path + normalized body.
3. SHA-256 hash the concatenated string.
4. Store the hash alongside the idempotency key.

## Failure & Partition Considerations
- Banking API timeouts: fail fast, record circuit breaker failure, and requeue transaction for later.
- Network partitions: resume from persisted `transactions.status` and ledger entries after recovery.
- Double-mint protection: status transitions are validated with optimistic locking on `transactions`.
