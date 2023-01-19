defmodule Hftx.Workers.Supervisor do
  @moduledoc """
  Worker Supervisor module

  Starts and keeps track of the worker processes: 
  - Agent
  - DataTransformer
  - DecisionMaker

  The reason for choosing `DynamicSupervisor` as the behaviour instead of `Supervisor` was to support dynamically adding more agents for an instrument. Not sure if this would ever be implemented.

  Since the name of the supervisor is dependent on the instrument_id, there can only be one running instance of this supervisor per instrument_id
  """
  use Supervisor
  alias Hftx.Workers.{DataTransformer, DecisionMaker, Agent}

  @spec name(String.t()) :: atom()
  def name(instrument_id) do
    ("WorkersSupervisor." <> instrument_id) |> String.to_atom()
  end

  def start_link(instrument_id) do
    Supervisor.start_link(__MODULE__, instrument_id, name: name(instrument_id))
  end

  @impl true
  def init(instrument_id) do
    Supervisor.init(generate_child_spec(instrument_id), strategy: :one_for_one)
  end

  defp generate_child_spec(instrument_id) do
    instrument = Application.get_env(:hftx, :instruments)
    instrument_config = instrument[instrument_id |> String.to_atom()]
    decision_maker_strategy = instrument_config[:decision_maker_strategy]
    data_transformer_strategy = instrument_config[:data_transformer_strategy]
    agent_strategies = instrument_config[:agent_strategies]

    decision_maker_spec = get_decision_maker_spec(instrument_id, decision_maker_strategy)
    data_transformer_spec = get_data_transformer_spec(instrument_id, data_transformer_strategy)
    agent_specs = get_agents_spec(instrument_id, agent_strategies)

    [decision_maker_spec, data_transformer_spec | agent_specs]
  end

  defp get_data_transformer_spec(_, nil),
    do: raise(ArgumentError, message: "Missing configuration for decision maker")

  defp get_data_transformer_spec(instrument_id, data_transformer_strategy) do
    %{
      id: "DataTransformer." <> (data_transformer_strategy |> Atom.to_string()),
      start: {DataTransformer, :start_link, [instrument_id, {data_transformer_strategy}]}
    }
  end

  defp get_decision_maker_spec(_, nil),
    do: raise(ArgumentError, message: "Missing configuration for decision maker")

  defp get_decision_maker_spec(instrument_id, decision_maker_strategy) do
    %{
      id: "DecisionMaker." <> (decision_maker_strategy |> Atom.to_string()),
      start: {DecisionMaker, :start_link, [instrument_id, {decision_maker_strategy}]}
    }
  end

  defp get_agents_spec(_, nil),
    do: raise(ArgumentError, message: "Missing configuration for agent workers")

  defp get_agents_spec(instrument_id, agent_strategies) do
    Enum.map(agent_strategies, fn strat ->
      id = "Agent." <> (strat |> Atom.to_string())

      # TODO: Get symbol value
      %{id: id, start: {Agent, :start_link, [instrument_id, {strat, ""}]}}
    end)
  end
end
