import Config

config :aura, Aura.Repo,
  username: "postgres",
  password: "postgres",
  database: "aura_dev",
  hostname: "localhost",
  pool_size: 10

config :aura,
  ecto_repos: [Aura.Repo],
  idempotency_ttl_hours: 24

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :transaction_id]
