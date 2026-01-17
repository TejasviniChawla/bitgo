defmodule Aura.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :client_id, :string, null: false
      add :bank_integration, :string, null: false
      add :amount, :bigint, null: false
      add :currency, :string, null: false
      add :destination_wallet, :string, null: false
      add :status, :string, null: false
      add :status_reason, :string
      add :idempotency_key, :uuid

      timestamps(type: :utc_datetime_usec)
    end

    create index(:transactions, [:bank_integration])
    create index(:transactions, [:status])
    create unique_index(:transactions, [:idempotency_key])
  end
end
