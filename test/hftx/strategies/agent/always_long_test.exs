defmodule Hftx.Strategies.Agent.AlwaysLongTest do
  use ExUnit.Case

  alias Hftx.Strategies.Agent.AlwaysLong
  alias Hftx.Data.Aggregate.CandleStick
  alias Hftx.Data.Agent.Suggestion, as: AgentSuggestion

  test "Evaluate the AlwaysLong agent strategy for CandleStick data" do
    market_events = [%CandleStick{open: 100, close: 50, high: 100, low: 50}]

    assert AlwaysLong.evaluate(AgentSuggestion.long(), market_events) ===
             {AgentSuggestion.long(), market_events}

    assert AlwaysLong.evaluate(AgentSuggestion.short(), market_events) ===
             {AgentSuggestion.long(), market_events}

    assert AlwaysLong.evaluate(AgentSuggestion.hold(), market_events) ===
             {AgentSuggestion.long(), market_events}
  end

  test "The event list never exceeds the historical_event_window" do
    market_event = %CandleStick{open: 100, close: 50, high: 100, low: 50}
    market_events = for _ <- 1..100, do: market_event

    {suggestion, updated_market_events} =
      AlwaysLong.evaluate(AgentSuggestion.long(), market_events)

    assert AgentSuggestion.long() === suggestion
    assert AlwaysLong.historical_event_window() === Enum.count(updated_market_events)
  end
end
