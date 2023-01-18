defmodule Hftx.Workers.Agent do
  @moduledoc """
  Worker process that emulates a trader. The worker is designed as an FSM using the gen_statem behaviour.
  Each worker process will operate on one symbol with one strategy. These can be set at the time of the initialization of the process.
  """
  @behaviour :gen_statem

  alias Hftx.Data.Agent.State, as: AgentState
  alias Hftx.Data.Aggregate

  @spec group_name(String.t()) :: String.t()
  def group_name(symbol) do
    "AgentGroup-" <> symbol
  end

  @spec name({module, String.t()}) :: String.t()
  def name({strategy, symbol}) do
    "Agent-" <> (strategy |> Atom.to_string()) <> "-" <> symbol
  end

  @spec observe({module, Aggregate.t()}) :: :ok
  def observe({symbol, event}) do
    # TODO: Get Pids from
    :gen_statem.cast(symbol, {:observe, event})
  end

  def start_link({name, strategy, symbol, instrument_id}, opts) do
    data = %AgentState{
      name: name,
      strategy: strategy,
      symbol: symbol,
      instrument_id: instrument_id
    }

    :gen_statem.start_link(__MODULE__, data, opts)
  end

  @impl true
  def callback_mode(), do: :handle_event_function

  @impl true
  def init(data) do
    {:ok, :init, data}
  end

  @impl true
  def handle_event(_caller, _event, _state, _data) do
    {:keep_state_and_data, []}
  end
end
