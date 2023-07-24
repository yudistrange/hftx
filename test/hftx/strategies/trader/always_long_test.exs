defmodule Hftx.Strategies.Trader.AlwaysLongTest do
  use ExUnit.Case

  alias Hftx.Strategies.Trader.AlwaysLong
  alias Hftx.Data.Aggregate.CandleStick
  alias Hftx.Data.Trader.Suggestion, as: TraderSuggestion

  test "Evaluate the AlwaysLong trader strategy for CandleStick data" do
    market_events = [%CandleStick{open: 100, close: 50, high: 100, low: 50}]

    assert AlwaysLong.evaluate(TraderSuggestion.long(), market_events) ===
             {TraderSuggestion.long(), market_events}

    assert AlwaysLong.evaluate(TraderSuggestion.short(), market_events) ===
             {TraderSuggestion.long(), market_events}

    assert AlwaysLong.evaluate(TraderSuggestion.hold(), market_events) ===
             {TraderSuggestion.long(), market_events}
  end

  test "The event list never exceeds the historical_event_window" do
    market_event = %CandleStick{open: 100, close: 50, high: 100, low: 50}
    market_events = for _ <- 1..100, do: market_event

    {suggestion, updated_market_events} =
      AlwaysLong.evaluate(TraderSuggestion.long(), market_events)

    assert TraderSuggestion.long() === suggestion
    assert AlwaysLong.historical_event_window() === Enum.count(updated_market_events)
  end
end
