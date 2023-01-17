defmodule Hftx.Strategies.Agent do
  @moduledoc """
  Base definition of Agent worker strategy behaviour
  """
  alias Hftx.Data.Aggregate
  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  @doc """
  Process a list of market event aggregates and suggest a response
  """
  @callback evaluate(market_history :: [Aggregate.t()]) :: AgentSuggestion.t()
end
