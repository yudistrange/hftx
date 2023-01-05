defmodule Hftx.Strategy do
  @moduledoc """
  Describes the behaviour for a particular strategy
  """
  # TODO: Handle more types of aggregate structs (if/when that happens) 
  alias Hftx.Data.Aggregate.CandleStick

  @callback observe(market_history :: [CandleStick.t()]) :: [CandleStick.t()]
end
