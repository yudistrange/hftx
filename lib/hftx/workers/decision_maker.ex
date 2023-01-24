defmodule Hftx.Workers.DecisionMaker do
  @moduledoc """
  GenServer process that emulates a decision maker

  This process will collat the agent suggestions and make a decision based on them.
  The actual [decision strategy](hftx/lib/hftx/strategies/decision_maker/decision_maker.ex) is injected at the time of startup
  """
  use GenServer
  require Logger
  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  @spec name(String.t()) :: String.t()
  def name(instrument_id), do: "DecisionMaker." <> instrument_id

  @spec observe(String.t(), {module, AgentSuggestion.t(), non_neg_integer()}) :: :ok
  def observe(instrument_id, {agent_strategy, agent_suggestion, agent_count}) do
    instrument_id
    |> name()
    |> Swarm.send({:observe, {agent_strategy, agent_suggestion}, agent_count})
  end

  @spec start_link(String.t(), {module}) ::
          :ignore | {:error, any} | {:ok, pid}
  def start_link(instrument_id, {decision_strategy}) do
    Logger.info("Starting Decision Maker: #{name(instrument_id)}")

    GenServer.start_link(__MODULE__, {decision_strategy, instrument_id},
      name: {:via, :swarm, name(instrument_id) <> (decision_strategy |> Atom.to_string())}
    )
  end

  @impl true
  def init({decision_strategy, instrument_id}) do
    {:ok,
     %{
       decision_strategy: decision_strategy,
       instrument_id: instrument_id,
       past_suggestions: [],
       past_actions: []
     }, {:continue, :register}}
  end

  @impl true
  def handle_continue(:register, state) do
    state |> Map.get(:instrument_id) |> name() |> Swarm.join(self())
    {:noreply, state}
  end

  @impl true
  def handle_cast(
        {:observe, agent_count, suggestion},
        %{
          decision_strategy: strategy,
          past_suggestions: past_suggestions,
          past_actions: past_actions,
          instrument_id: instrument_id
        } = state
      ) do
    Logger.debug("Received suggestion: ")
    if Enum.count(past_suggestions) >= agent_count do
      decision = decide({strategy, :transform, [suggestion | past_suggestions]}, instrument_id)
      {:noreply, state |> Map.put(:past_actions, [decision | past_actions])}
    else
      {:noreply, state |> Map.put(:past_suggestions, [suggestion | past_suggestions])}
    end
  end

  defp decide({module, func, args}, _instrument_id) do
    decision = apply(module, func, args)

    # TODO:
    # - Place the order according to decision
    # - Save the order in the database

    decision
  end
end
