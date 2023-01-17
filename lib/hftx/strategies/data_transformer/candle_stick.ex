defmodule Hftx.Strategies.DataTransformer.CandleStick do
  @moduledoc """
  `DataTransformer` behaviour implementation that converts `MarketEvent` data into `CandleStick` aggregate
  """
  @behaviour Hftx.Strategies.DataTransformer

  require Logger
  alias Hftx.Data.Transformer.CandleStick
  alias Hftx.Data.Aggregate.CandleStick

  @impl true
  def transform(market_events) do
    close_price = List.first(market_events) |> Map.get(:last_trade_price)
    open_price = List.last(market_events) |> Map.get(:last_trade_price)

    {lowest, highest} =
      Enum.min_max_by(market_events, fn e ->
        Map.get(e, :last_trade_price)
      end)

    %CandleStick{
      open: open_price,
      close: close_price,
      high: highest |> Map.get(:last_trade_price),
      low: lowest |> Map.get(:last_trade_price),
      filled: open_price < close_price
    }
  end
end
