defmodule Aura.Repo.Migrations.CreateLedgerEntries do
  use Ecto.Migration

  def change do
    create table(:ledger_entries, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :transaction_id, :uuid, null: false
      add :account_id, :string, null: false
      add :amount, :bigint, null: false
      add :currency, :string, null: false
      add :entry_type, :string, null: false
      add :metadata, :map

      timestamps(type: :utc_datetime_usec)
    end

    create index(:ledger_entries, [:transaction_id])
    create index(:ledger_entries, [:account_id])
  end
end
