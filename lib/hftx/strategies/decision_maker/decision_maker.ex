defmodule Hftx.Strategies.DecisionMaker do
  @moduledoc """
  Base decision_maker behaviour definition
  """
  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  @callback decide(suggestions :: [{module, AgentSuggestion.t()}]) :: AgentSuggestion.t()
end
