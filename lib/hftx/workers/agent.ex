defmodule Hftx.Workers.Agent do
  @moduledoc """
  Worker process that emulates a trader. The worker is designed as an FSM using the gen_statem behaviour.
  Each worker process will operate on one symbol with one strategy. These can be set at the time of the initialization of the process.
  """
  @behaviour :gen_statem

  require Logger
  alias Hftx.Data.Agent.State, as: AgentState

  @spec group_name(String.t()) :: String.t()
  def group_name(instrument_id) do
    "AgentGroup." <> instrument_id
  end

  @spec name({module, String.t()}) :: String.t()
  def name({strategy, instrument_id}) do
    "Agent." <> (strategy |> Atom.to_string()) <> "." <> instrument_id
  end

  @spec start_link(String.t(), {module, String.t()}) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(instrument_id, {strategy, symbol}) do
    data = %AgentState{
      name: name({strategy, symbol}),
      strategy: strategy,
      symbol: symbol,
      instrument_id: instrument_id,
      events: []
    }

    :gen_statem.start_link({:via, :swarm, name({strategy, instrument_id})}, __MODULE__, data, [])
  end

  @impl true
  def callback_mode(), do: :handle_event_function

  @impl true
  def init(%{instrument_id: instrument_id} = data) do
    instrument_id |> group_name() |> Swarm.join(self())
    {:ok, :init, data}
  end

  @impl true
  def handle_event(
        _sender,
        {:observe, event},
        state,
        %{strategy: strategy, events: events} = data
      ) do
    {next_state, updated_event_list} = apply(strategy, :evaluate, [state, [event | events]])

    cond do
      next_state == state ->
        {:keep_state, data |> Map.put(:events, updated_event_list)}

      next_state != state ->
        {:next_state, next_state, data |> Map.put(:events, updated_event_list)}
    end
  end

  @impl true
  def handle_event(_sender, event, _state, %{name: name}) do
    Logger.error("Received unhandled event in #{name} agent: #{event}")
    {:keep_state_and_data, []}
  end
end
