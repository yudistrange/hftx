defmodule Hftx.Agent.Worker do
  @behaviour :gen_statem

  alias Hftx.Agent.State, as: AgentState

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

  def handle_event(_caller, event, _state, _data) do
    IO.inspect(event, label: "Unhandled event")
    {:keep_state_and_data, []}
  end

  def handle_event(_caller, event, _state, _data) do
    IO.inspect(event, label: "Unhandled event")
    {:keep_state_and_data, []}
  end

  def handle_event(_caller, event, _state, _data) do
    IO.inspect(event, label: "Unhandled event")
    {:keep_state_and_data, []}
  end

  def handle_event(_caller, event, _state, _data) do
    IO.inspect(event, label: "Unhandled event")
    {:keep_state_and_data, []}
  end
end
