defmodule Hftx.Strategies.Trader do
  @moduledoc """
  Base definition of Trader worker strategy behaviour
  """
  alias Hftx.Data.Aggregate
  alias Hftx.Data.Trader.Suggestion, as: TraderSuggestion

  @doc """
  Process a list of market event aggregates and suggest a response
  """
  @callback historical_event_window() :: non_neg_integer()
  @callback evaluate(previous_suggestion :: TraderSuggestion, market_history :: [Aggregate.t()]) ::
              {TraderSuggestion.t(), [Aggregate.t()]}
end
