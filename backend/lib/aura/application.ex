defmodule Aura.Application do
  use Application

  def start(_type, _args) do
    children = [
      Aura.Repo,
      {Registry, keys: :unique, name: Aura.TransactionRegistry},
      {DynamicSupervisor, name: Aura.TransactionSupervisor, strategy: :one_for_one},
      Aura.CircuitBreaker
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Aura.Supervisor)
  end
end
