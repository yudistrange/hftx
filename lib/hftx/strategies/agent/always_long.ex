defmodule Hftx.Strategies.Agent.AlwaysLong do
  @moduledoc """
  AgentStrategy that always goes :long

  THIS IS FOR TESTNIG PURPOSE ONLY
  """
  @behaviour Hftx.Strategies.Agent

  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  @impl true
  def evaluate(_market_history) do
    AgentSuggestion.long()
  end
end
