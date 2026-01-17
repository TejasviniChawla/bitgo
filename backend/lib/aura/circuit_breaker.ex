defmodule Aura.CircuitBreaker do
  use GenServer

  @window_ms 60_000
  @failure_threshold 5

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def record_failure(integration) do
    GenServer.cast(__MODULE__, {:failure, integration})
  end

  def record_success(integration) do
    GenServer.cast(__MODULE__, {:success, integration})
  end

  def halted?(integration) do
    GenServer.call(__MODULE__, {:halted?, integration})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:failure, integration}, state) do
    now = System.system_time(:millisecond)
    entry = Map.get(state, integration, %{failures: [], halted_until: nil})
    failures = Enum.filter(entry.failures, &(&1 > now - @window_ms)) ++ [now]
    halted_until = if length(failures) >= @failure_threshold, do: now + @window_ms, else: entry.halted_until

    {:noreply, Map.put(state, integration, %{failures: failures, halted_until: halted_until})}
  end

  def handle_cast({:success, integration}, state) do
    entry = Map.get(state, integration, %{failures: [], halted_until: nil})
    {:noreply, Map.put(state, integration, %{entry | failures: []})}
  end

  @impl true
  def handle_call({:halted?, integration}, _from, state) do
    now = System.system_time(:millisecond)
    entry = Map.get(state, integration, %{failures: [], halted_until: nil})
    halted = entry.halted_until != nil and entry.halted_until > now
    {:reply, halted, state}
  end
end
