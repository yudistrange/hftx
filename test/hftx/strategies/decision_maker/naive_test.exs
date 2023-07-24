defmodule Hftx.Strategies.DecisionMaker.NaiveTest do
  use ExUnit.Case

  alias Hftx.Strategies.DecisionMaker.Naive
  alias Hftx.Data.Trader.Suggestion, as: TraderSuggestion

  test "Decide based on first trader's suggestion" do
    assert Naive.decide([
             {TraderStrat, TraderSuggestion.long()},
             {TraderStrat, TraderSuggestion.hold()}
           ]) ===
             TraderSuggestion.long()
  end
end
