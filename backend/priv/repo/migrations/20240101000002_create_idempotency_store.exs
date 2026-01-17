defmodule Aura.Repo.Migrations.CreateIdempotencyStore do
  use Ecto.Migration

  def change do
    create table(:idempotency_store, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :key, :uuid, null: false
      add :request_hash, :string, null: false
      add :response_body, :map, null: false
      add :status_code, :integer, null: false
      add :expires_at, :utc_datetime_usec, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:idempotency_store, [:key])
    create index(:idempotency_store, [:expires_at])
  end
end
