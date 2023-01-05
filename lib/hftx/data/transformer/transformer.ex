defmodule Hftx.Data.Transformer do
  @moduledoc """
  Describes the behaviour for various data compression strategies.
  Compression strategies are used to aggregate the Market Price data into compact form.
  """
  alias Hftx.Data.Market.Event, as: MarketEvent
  alias Hftx.Data.Aggregate.CandleStick

  # TODO: Handle other aggregate structs when they are added
  @callback update(market_event :: MarketEvent.t()) :: CandleStick.t()
end
