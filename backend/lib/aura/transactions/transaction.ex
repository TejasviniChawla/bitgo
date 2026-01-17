defmodule Aura.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses [:initiated, :fiat_pending, :compliance_cleared, :settling_on_chain, :completed, :halted]
  @required_fields ~w(client_id bank_integration amount currency destination_wallet status)a

  schema "transactions" do
    field :client_id, :string
    field :bank_integration, :string
    field :amount, :integer
    field :currency, :string
    field :destination_wallet, :string
    field :status, Ecto.Enum, values: @statuses, default: :initiated
    field :status_reason, :string
    field :idempotency_key, Ecto.UUID

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required_fields ++ [:status_reason, :idempotency_key])
    |> validate_required(@required_fields)
  end
end
