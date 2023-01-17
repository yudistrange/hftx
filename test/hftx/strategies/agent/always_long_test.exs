defmodule Hftx.Strategies.Agent.AlwaysLongTest do
  use ExUnit.Case

  alias Hftx.Strategies.Agent.AlwaysLong
  alias Hftx.Data.Aggregate.CandleStick
  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  test "Evaluate the AlwaysLong agent strategy for CandleStick data" do
    market_events = [%CandleStick{open: 100, close: 50, high: 100, low: 50}]

    assert AlwaysLong.evaluate(market_events) === AgentSuggestion.long()
  end
end
