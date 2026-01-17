defmodule Aura.Transactions.StateMachine do
  use GenServer

  alias Aura.CircuitBreaker
  alias Aura.Transactions.Transaction

  def start_link(%Transaction{id: id} = transaction) do
    GenServer.start_link(__MODULE__, transaction, name: via(id))
  end

  def via(id), do: {:via, Registry, {Aura.TransactionRegistry, id}}

  def advance(id, event) do
    GenServer.cast(via(id), {:advance, event})
  end

  @impl true
  def init(transaction) do
    {:ok, transaction}
  end

  @impl true
  def handle_cast({:advance, :fiat_received}, transaction) do
    {:noreply, %{transaction | status: :fiat_pending}}
  end

  def handle_cast({:advance, :compliance_clear}, transaction) do
    {:noreply, %{transaction | status: :compliance_cleared}}
  end

  def handle_cast({:advance, :settle_on_chain}, transaction) do
    halted = CircuitBreaker.halted?(transaction.bank_integration)

    new_status = if halted, do: :halted, else: :settling_on_chain
    {:noreply, %{transaction | status: new_status}}
  end

  def handle_cast({:advance, :complete}, transaction) do
    {:noreply, %{transaction | status: :completed}}
  end

  def handle_cast({:advance, {:halted, reason}}, transaction) do
    {:noreply, %{transaction | status: :halted, status_reason: reason}}
  end

  def handle_cast({:advance, _event}, transaction) do
    {:noreply, transaction}
  end
end
