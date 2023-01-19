defmodule Hftx.Strategies.DecisionMaker.NaiveTest do
  use ExUnit.Case

  alias Hftx.Strategies.DecisionMaker.Naive
  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  test "Decide based on first agent's suggestion" do
    assert Naive.decide([
             {AgentStrat, AgentSuggestion.long()},
             {AgentStrat, AgentSuggestion.hold()}
           ]) ===
             AgentSuggestion.long()
  end
end
