defmodule Aura.Ledger.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(transaction_id account_id amount currency entry_type)a

  schema "ledger_entries" do
    field :transaction_id, Ecto.UUID
    field :account_id, :string
    field :amount, :integer
    field :currency, :string
    field :entry_type, Ecto.Enum, values: [:debit, :credit]
    field :metadata, :map, default: %{}

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(entry, attrs) do
    entry
    |> cast(attrs, @required_fields ++ [:metadata])
    |> validate_required(@required_fields)
  end
end
