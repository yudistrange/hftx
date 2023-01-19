defmodule Hftx.Strategies.Agent.AlwaysLong do
  @moduledoc """
  AgentStrategy that always goes :long

  THIS IS FOR TESTNIG PURPOSE ONLY
  """
  @behaviour Hftx.Strategies.Agent

  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  @impl true
  def historical_event_window(), do: 50

  @impl true
  def evaluate(_previous_suggestion, market_history) do
    {AgentSuggestion.long(), market_history |> Enum.take(historical_event_window())}
  end
end
