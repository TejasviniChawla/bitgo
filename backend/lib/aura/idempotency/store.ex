defmodule Aura.Idempotency.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(key request_hash response_body status_code expires_at)a

  schema "idempotency_store" do
    field :key, Ecto.UUID
    field :request_hash, :string
    field :response_body, :map
    field :status_code, :integer
    field :expires_at, :utc_datetime_usec

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(store, attrs) do
    store
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:key)
  end
end
