defmodule Hftx.Strategy do
  @moduledoc """
  Describes the behaviour for a particular strategy
  """
  alias Hftx.Data.Aggregate

  @callback observe(market_history :: [Aggregate.t()]) :: [Aggregate.t()]
end
