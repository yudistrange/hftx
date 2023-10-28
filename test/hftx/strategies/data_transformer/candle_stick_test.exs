defmodule Hftx.Strategies.DataTransformer.CandleStickTest do
  use ExUnit.Case

  alias Hftx.Strategies.DataTransformer.CandleStick, as: CandleStickTransformer
  alias Hftx.Data.EquityEvent
  alias Hftx.Data.Aggregate.CandleStick

  test "Create CandleStick Aggregate from a list of MarketEvent Data" do
    market_events = [
      %EquityEvent{
        timestamp: DateTime.utc_now(),
        symbol: "tsla",
        instrument_token: 1,
        last_trade_price: 100,
        last_trade_volume: 1
      }
    ]

    assert CandleStickTransformer.transform(market_events) == %CandleStick{
             open: 100,
             close: 100,
             high: 100,
             low: 100,
             filled: false
           }
  end
end
