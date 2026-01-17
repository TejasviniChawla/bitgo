defmodule Aura.Repo.Migrations.AddIdempotencyRequestHashIndex do
  use Ecto.Migration

  def change do
    create index(:idempotency_store, [:request_hash])
  end
end
