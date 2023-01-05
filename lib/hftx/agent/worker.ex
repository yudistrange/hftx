defmodule Hftx.Agent.Worker do
  @moduledoc """
  Worker process that emulates a trader. The worker is designed as an FSM using the gen_statem behaviour.
  Each worker process will operate on one symbol with one strategy. These can be set at the time of the initialization of the process.
  """
  @behaviour :gen_statem

  alias Hftx.Data.Agent.State, as: AgentState

  def start_link({name, strategy, symbol}, opts) do
    data = %AgentState{name: name, strategy: strategy, symbol: symbol}
    :gen_statem.start_link(__MODULE__, data, opts)
  end

  @impl true
  def callback_mode(), do: :handle_event_function

  @impl true
  def init(data) do
    {:ok, :init, data}
  end

  def handle_event(_caller, event, _state, _data) do
    IO.inspect(event, label: "Unhandled event")
    {:keep_state_and_data, []}
  end
end
