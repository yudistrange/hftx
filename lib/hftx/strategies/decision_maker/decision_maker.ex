defmodule Hftx.Strategies.DecisionMaker do
  @moduledoc """
  Base decision_maker behaviour definition
  """
  alias Hftx.Data.Trader.Suggestion, as: TraderSuggestion

  @callback decide(suggestions :: [{module, TraderSuggestion.t()}]) :: TraderSuggestion.t()
end
