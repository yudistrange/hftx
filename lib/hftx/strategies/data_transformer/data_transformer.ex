defmodule Hftx.Strategies.DataTransformer do
  @moduledoc """
  Base data_transformer behaviour definition

  These strategies would be used for data compression - convert MarketEvent data into
  Aggregate data
  """
  alias Hftx.Data.MarketEvent
  alias Hftx.Data.Aggregate

  @callback aggregation_size() :: non_neg_integer()
  @callback transform(market_event :: [MarketEvent.t()]) ::
              Aggregate.t()
end
